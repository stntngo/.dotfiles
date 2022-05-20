(module dotfiles.plugins.dap
  {require {dap   dap
            dapui dapui}})

(set dap.adapters.go
     {:type :server
      :host "127.0.0.1"
      :port  2345})

(set dap.configurations.go
     [{:type      :go
       :name      "Go: remote"
       :cwd       (os.getenv "GOPATH")
       :remotePath "src/"
       :showLog   true
       :trace     :verbose
       :mode      :remote
       :request   :attach}])

(dapui.setup)
