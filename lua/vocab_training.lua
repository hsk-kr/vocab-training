local M = {}

-- Utility function to read a JSON file
local function read_json(file_path)
  local f = io.open(file_path, "r") -- Open the file in read mode
  if not f then
    error("Could not open file: " .. file_path)
  end
  local content = f:read("*a") -- Read the entire file
  f:close()
  return vim.fn.json_decode(content) -- Parse JSON content
end

-- Function to get the directory of the current module
local function get_plugin_dir()
  local path = debug.getinfo(1, "S").source:sub(2) -- Get full file path
  return vim.fn.fnamemodify(path, ":h")           -- Get directory name
end

-- Load vocabulary data
M.vocab_data = function()
  local plugin_dir = get_plugin_dir()
  local data_path = plugin_dir .. "/../data/vocab.json"
  return read_json(data_path)
end

-- Get a random question from the vocabulary data
M.get_random_question = function()
  local vocab = M.vocab_data()["elementary"]
  math.randomseed(os.time()) -- Seed random generator
  return vocab[math.random(#vocab)] -- Return a random word
end

-- Start the vocabulary game
M.start_game = function()
  local question = M.get_random_question()
  local buf = vim.api.nvim_create_buf(false, true) -- Create a scratch buffer

  local description = "Guess the word: " .. question.description
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { description })

  print("Guess the word: " .. question.description .. "\n")

  -- User input for guessing the word
  local answer = vim.fn.input("Your guess: ")
  if answer:lower() == question.en:lower() then
    print("\nCorrect!")
  else
    print("\nIncorrect! The answer was: " .. question.en)
  end
end

return M
