local function wubivoice_single_char_filter(input, env)
  local single_char = env.engine.context:get_option("single_char")
  for candidate in input:iter() do
    if not single_char or utf8.len(candidate.text) == 1 then
      yield(candidate)
    end
  end
end

return wubivoice_single_char_filter
