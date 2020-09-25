defmodule Example.Count do
  def income(user_price, vps_price, vps_mem, vps_count) do
    usd_2_cny = 6.8
    min_mem = 64
    user_count_per_vps = vps_mem / min_mem
    income = (user_price * user_count_per_vps - vps_price * usd_2_cny) * vps_count
    income_per_user = income / (user_count_per_vps * vps_count)
    IO.puts "income: #{income}"
    IO.puts "user_count: #{user_count_per_vps * vps_count}"
    IO.puts "income_per_user: #{income_per_user}"
  end
end


# Example.Count.income(5, 5, 1024, 1)

Example.Count.income(15, 40, 1024*8, 1)

# Example.Count.income(5, 640, 1024*96, 1)
