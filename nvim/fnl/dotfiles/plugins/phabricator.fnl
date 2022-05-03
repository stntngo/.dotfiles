(module dotfiles.plugins.phabricator
  {require {nvim    aniseed.nvim
            core    aniseed.core
            astr    aniseed.string
            job     plenary.job
            prelude prelude
            vimp    vimp}})

(local diff-template "Summary: 

Test Plan: 

Reviewers: 

Subscribers: 

Tags: 

Revert Plan: 

JIRA Issues: 

API Changes: 

Monitoring and Alerts:
")

(local diff-separator "# ------------------------ >8 ------------------------")

(defn- is-diff-separator? [x] (= x diff-separator))

(defn- get-tmp-dir []
  "Returns the operating system's configured temporary file
   directory, defaulting to /tmp/ if $TMPDIR is unconfigured."
   (or (os.getenv :TMPDIR)
       "/tmp/"))

(defn- tmp-diff []
  "Generate a new DIFF_EDITMSG file path in the system's
   temporary file directory"

  ; TODO: Store DIFF_EDITMSG local to git repo.
  ;
  ; It could be nice to store the DIFF_EDITMSG inside
  ; of the git repo's .arcconfig directory, similar 
  ; to the way that COMMIT_EDITMSG is created and 
  ; stored inside of the repo's .git directory.
  ;
  ; The only downside there is that I'll have to
  ; manage the lifetime of this file myself rather.
  (.. (get-tmp-dir) "DIFF_EDITMSG" (prelude.rand-str 8)))

(defn- append-to-buffer [win buf]
  "Callback hook for use with plenary.job that will asynchrnously
   append any lines passed to the returned function to the specified
   buffer and window.

   NOTE: The returned function has rudimentary 'auto-scrolling' and
   assumes that you do not navigate away from the buffer that has been
   created for you."
  (fn [_ data]
    (vim.schedule
      (fn []
        (vim.fn.appendbufline buf :$ data)
        (when (= (nvim.get_current_buf) buf)
          (nvim.win_set_cursor
            win
            [(nvim.buf_line_count buf) 0]))))))

(defn- submit-arc-diff [path]
  "Submits the Differential stored at path to the
   phabricator repository configured for the current
   working directory"
  (nvim.command "topleft new")
  (let [win (nvim.get_current_win)
        buf (nvim.get_current_buf)
        j (job:new
            {:command :arc
             :args ["diff" "--create" "-F" path]
             :on_stdout (append-to-buffer win buf)})]
    (j:start)))

(defn- git-commit-history []
  "Constructs a list of strings in which each string represents
   a single git commit with the form {hash} {message}"
  (let [j (job:new
            {:command :git
             :args ["log" "--pretty=oneline"]})]
    (j:start)
    (j:wait)
    (if (= j.code 0)
        (j:result)
        nil)))

(defn- git-commit-head []
  "Returns the commit hash of HEAD within the current repository"
  (let [j (job:new
            {:command :git
             :args [:rev-parse :HEAD]})]
    (j:start)
    (j:wait)
    (if (= j.code 0)
        (core.first (j:result))
        nil)))

(defn- git-diff [a b]
  "Constructs the full diff between commit hash a and commit hash b
   as a list of text lines."
  (let [j (job:new
            {:command :git
             :args [:diff a b]})]
    (j:start)
    (j:wait)
    (j:result)))

(defn- git-ancestry-path [a b]
  "Constructs a list of short, oneliner commits between commit hash
   a and commit hash b"
  (let [j (job:new
            {:command :git
             :args [:log "--oneline" (.. a ".." b)]})]
    (j:start)
    (j:wait)
    (j:result)))

(defn- select-base-commit []
  "Prompts the user to select a base commit from the list
   of the ten most recent commits on the current branch."
  (let [commits (git-commit-history)
        result {}]
    (when commits
      (vim.ui.select
        (-> commits
            core.rest
            (prelude.take 10))
        {:prompt "Select a base git commit"}
        (fn [choice]
          (table.insert result choice))))
    (-> result
        core.first
        (astr.split " ")
        core.first)))

(defn- remove-diff [lines]
  "Remove all lines from the diff body following the diff separator.
   Any line remaining above the diff line separator will be part of
   the diff body visible on phabricator. So be careful what you incldue."
  (-> lines
      (prelude.take-while 
        (fn [line]
          (not (is-diff-separator? line))))))

(defn diff-create []
  "Prompts the user for a diff title and a base commit before opening a new
   temporary buffer holding the default diff template. Once the diff template
   buffer closes, the diff is submitted for review to phabricator."
  (vim.ui.input
    {:prompt "Enter Diff Title: "}
    (fn [title]
      (nvim.command "topleft new")
      (let [base-commit (select-base-commit)
            head        (git-commit-head)
            line-diff   (git-diff head base-commit)
            hack        (tmp-diff)
            template    (core.concat
                          [title ""]
                          (astr.split diff-template "\n")
                          [diff-separator
                           "# Do not modify or remove the line above."
                           "# Everything below it will be ignored."
                           "#"
                           (.. "# Clean File Location: " hack)
                           "#"
                           "# Please fill out the diff template for your revision. Lines starting"
                           "# with '#' will be ignored, and an empty message aborts the diff."     ; XXX: Does it though?
                           "#"
                           "# NOTE: This diff template is hardcoded and may not reflect all custom fields"
                           "# configured by the application administrators."
                           "#"
                           "# Commits to be included:"
                           "#"]
                          (->> (git-ancestry-path base-commit head)
                               (core.map
                                 (fn [commit]
                                   (.. "#\t" commit)))) 
                          line-diff)
            win (nvim.get_current_win)
            buf (nvim.get_current_buf)
            path (tmp-diff)]

        (nvim.create_autocmd
          :QuitPre
          {:buffer buf
           :callback (fn []
                       (let [ppath (require :plenary.path)
                             f (ppath:new hack)
                             filtered (-> (vim.api.nvim_buf_get_lines buf 0 -1 false)
                                          (prelude.take-while (fn [x] (not (is-diff-separator? x)))))
                             payload (astr.join "\n" filtered)]
                         (f:write payload :w)
                         (submit-arc-diff hack)))})

        (nvim.buf_set_option buf :swapfile false)
        (nvim.buf_set_option buf :filetype :gitcommit)

        (vim.api.nvim_buf_set_name buf path)
        (vim.api.nvim_buf_set_lines buf 0 -1 false template)))))

(vimp.nnoremap :<leader>ad diff-create)
