-- Rails app uses minitest (test/), not rspec, so swap in the minitest adapter
return {
  { "zidhuss/neotest-minitest" },
  {
    "nvim-neotest/neotest",
    opts = {
      adapters = {
        ["neotest-minitest"] = {},
      },
    },
  },
}
