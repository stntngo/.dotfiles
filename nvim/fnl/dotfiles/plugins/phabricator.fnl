(module dotfiles.plugins.phabricator
  {require {nvim aniseed.nvim
            core aniseed.core
            astr aniseed.string
            job  plenary.job
            vimp vimp}})

; job:new
; (vim.inspect job:new)

; local Job = require'plenary.job'

; Job:new({
;   command = 'rg',
;   args = { '--files' },
;   cwd = '/usr/bin',
;   env = { ['a'] = 'b' },
;   on_exit = function(j, return_val)
;     print(return_val)
;     print(j:result())
;   end,
; }):sync() -- or start()

; local job = Job:new {
;         command = "cat",

;         on_stdout = function(_, data)
;           table.insert(results, data)
;         end,
;       }

;       job:start()
;       job:send "hello\n"
;       job:send "world\n"
;       job:shutdown()

; (local test-table {})

; (table.insert test-table 2)

; (nvim.create_buf true true)

; (let [win (nvim.get_current_win)
;       buf (nvim.create_buf true true)
;       results {}
;       cat (job:new
;             {:command :rg
;              :args ["--files"]
;              :cwd "/Users/niels/go-code"
;              :on_stdout (vim.schedule_wrap
;                           (fn [_ data]
;                             (vim.fn.appendbufline buf :$ data)))})]
;   (nvim.win_set_buf win buf)
;   (cat:start)
;   (cat:wait))

; test-table


; local Job = require'plenary.job'

; Job:new({
;   command = 'rg',
;   args = { '--files' },
;   cwd = '/usr/bin',
;   env = { ['a'] = 'b' },
;   on_exit = function(j, return_val)
;     print(return_val)
;     print(j:result())
;   end,
; }):sync() -- or start()

; vim.

; (let [rg (job:new
;   {:command :rg
;    :args ["--files"]
;    :cwd "/usr/bin"
;    :on_stdout (vim.schedule_wrap (fn [_ data]
;                 (vim.notify data)))
;    :on_stderr (vim.schedule_wrap (fn [_ data]
;                 (vim.notify data))))]
;    rg)
;    (rg:sync (* 60 1000)))

; (let [loop vim.loop
;       stdout (loop.new_pipe false)
;       stderr (loop.new_pipe false)
;       handle (loop.spawn
;                :rg
;                {:args ["loop"
;                        "--vimgrep"
;                        "--smart-case"
;                        "--block"]
;                 :stdio [nil stdout stderr]}
;                (fn [x y]
;                  (stdout:read_stop)
;                  (stderr:read_stop)
;                  (stdout:close)
;                  (stderr:close)
;                  (handle:close)
;                  (print x)
;                  (print y)))]
;   (loop.read_start stdout (fn [x y]
;                             (print x)
;                             (print y)))
;   (loop.read_start stderr (fn [x y]
;                             (print x)
;                             (print y))))


; (local loop vim.loop)
; (local api vim.api)

; (let [shortname (vim.fn.expand "%:t:r")
;       fullname (nvim.buf_get_name 0)]
;   (print shortname)
;   (print fullname))



; (defn- range [lo hi]
;   (if (= lo hi)
;     [lo]
;     (core.concat [lo] (range (core.inc lo) hi))))

; (local charset
;   (core.map
;     (fn [x]
;       (string.char x))
;     (core.concat
;       (range 48 57)
;       (range 75 90)
;       (range 97 122))))

; (defn- rand-str [len]
;   (if (= 0 len)
;     ""
;     (.. (. charset (math.random 1 (length charset)))
;         (rand-str (core.dec len)))))

; (defn- tmp-diff []
;   (.. "/tmp/diff-" (rand-str 8)))

; (defn- arc-diff-command [path]
;   {:command :arc
;    :args    ["diff" "--create" "-F" path]
;    :on_exit (fn [j ret]
;               (print j)
;               (print ret))})

; (defn- arc-cb [path]
;   (fn []
;     (let [p (-> path
;                 arc-diff-command
;                 job:new)]
;       (p:sync))))

; (local diff-template "Summary: 

; Test Plan: 

; Reviewers: 

; Subscribers: 

; Tags: 

; Revert Plan: 

; JIRA Issues: 

; API Changes: 

; Monitoring and Alerts:")

; (defn diff-create []
;   (let [win (nvim.get_current_win)
;         buf (nvim.create_buf true false)
;         path (tmp-diff)]
;     (vim.api.nvim_buf_set_name buf path)
;     (nvim.create_autocmd
;       :BufLeave
;       {:buffer buf
;        :once true
;        :callback (arc-cb path)})

;     ; TODO: Search to see if there is an existing diff message open.
;     (vim.ui.input
;       {:prompt "Enter Diff Title: "}
;       (fn [title]
;         (let [template (.. title "\n\n" diff-template)]
;           (vim.api.nvim_buf_set_lines buf 0 -1 false (astr.split template "\n"))
;           (nvim.win_set_buf win buf))))))

; (set vimp.always_override true)
; (vimp.nnoremap :<leader>ad diff-create)
