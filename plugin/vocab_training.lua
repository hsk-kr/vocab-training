vim.api.nvim_create_user_command("VocabGameStart", function()
  require("vocab_training").start_game()
end, {})
