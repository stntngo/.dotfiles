(module dotfiles.plugins.phabricator
  {require {nvim aniseed.nvim
            core aniseed.core
            astr aniseed.string
            job  plenary.job
            vimp vimp}})

(defn- range [lo hi]
  "Eagerly returns a list of numbers from lo to hi, inclusive"
  (if (= lo hi)
    [lo]
    (core.concat [lo] (range (core.inc lo) hi))))

(local charset
    (core.map
    (fn [x]
      (string.char x))
    (core.concat
      (range 48 57)
      (range 75 90)
      (range 97 122))))

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

(defn- reverse [xs]
  "Eagerly reverse the elements of a list"
  (when (not (core.empty? xs))
    (core.concat [(core.last xs)]
                 (reverse (core.butlast xs)))))

(defn- take [xs n]
  "Eagerly construct a new list of up to the first n elements of a provided list"
  (when (and (> n 0)
             (not (core.empty? xs)))
    (core.concat [(core.first xs)]
                  (take (core.rest xs) (core.dec n)))))

(defn- take-while [xs pred]
  ; TODO: Write docstring
  (let [x  (core.first xs)
        xs (core.rest xs)]
    (when (pred x)
      (core.concat [x]
                   (take-while xs pred)))))

(defn- rand-str [len]
  "Generates a random alphanumeric string of the specified length"
  (if (= 0 len)
    ""
    (.. (. charset (math.random 1 (length charset)))
        (rand-str (core.dec len)))))

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
  (.. (get-tmp-dir) "DIFF_EDITMSG" (rand-str 8)))

(defn- append-to-buffer [win buf]
  (fn [_ data]
    (vim.schedule
      (fn []
        (vim.fn.appendbufline buf :$ data)
        (when (= (nvim.get_current_buf) buf)
          (nvim.win_set_cursor
            win
            [(nvim.buf_line_count buf) 0]))))))

(defn- submit-arc-diff [path]
  (nvim.command "topleft new")
  (let [win (nvim.get_current_win)
        buf (nvim.get_current_buf)
        j (job:new
            {:command :arc
             :args ["diff" "--create" "-F" path]
             :on_stdout (append-to-buffer win buf)})]
    (j:start)))

(defn- git-commit-history []
  (let [j (job:new
            {:command :git
             :args ["log" "--pretty=oneline"]})]
    (j:start)
    (j:wait)
    (if (= j.code 0)
        (j:result)
        nil)))

(defn- git-commit-head []
  (let [j (job:new
            {:command :git
             :args [:rev-parse :HEAD]})]
    (j:start)
    (j:wait)
    (if (= j.code 0)
        (core.first (j:result))
        nil)))

(defn- git-diff [a b]
  (let [j (job:new
            {:command :git
             :args [:diff a b]})]
    (j:start)
    (j:wait)
    (j:result)))

(defn- git-ancestry-path [a b]
  (let [j (job:new
            {:command :git
             :args [:log "--oneline" (.. a ".." b)]})]
    (j:start)
    (j:wait)
    (j:result)))

(defn- select-base-commit []
  (let [commits (git-commit-history)
        result {}]
    (when commits
      (vim.ui.select
        (-> commits
            core.rest
            (take 10))
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
      (take-while 
        (fn [line]
          (not (is-diff-separator? line))))))

(defn diff-create []
    ; TODO: See if there is an existing diff message... somehow...
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
            :BufWritePre
            {:buffer buf
             :callback (fn []
                         (let [ppath (require :plenary.path)
                               f (ppath:new hack)
                               filtered (-> (vim.api.nvim_buf_get_lines buf 0 -1 false)
                                            (take-while (fn [x] (not (is-diff-separator? x)))))
                               payload (astr.join "\n" filtered)]
                           (f:write payload :w)
                           (submit-arc-diff hack)))})

          (nvim.buf_set_option buf :swapfile false)
          (nvim.buf_set_option buf :filetype :gitcommit)

          (vim.api.nvim_buf_set_name buf path)
          (vim.api.nvim_buf_set_lines buf 0 -1 false template)))))

(vimp.nnoremap :<leader>ad diff-create)
