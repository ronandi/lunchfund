defmodule Lunchfund do

  def get_hours_since_last_commit(user) do
    {:ok, events} = Github.get("users/#{user}/events").body
    pushes = Enum.filter(events, fn(event) -> Dict.get(event, :type) == "PushEvent" end)
    if (pushes == []) do
      9000
    else
      commit_date_str = hd(pushes) |> Dict.get(:created_at)
      {:ok, last_commit_date} = Timex.DateFormat.parse(commit_date_str, "{ISOz}")
      Timex.Date.diff(last_commit_date, Timex.Date.now, :hours)
    end
  end

  def charge_user(user, token, note, amount) do
    if (amount < 0) do
      raise "Negative amount argument will be a payment!"
    end
    headers = %{"Content-type" => "application/x-www-form-urlencoded"}
    body = URI.encode_query([access_token: token, user_id: user, note: note, amount: -amount])
    resp_body = Venmo.post("payments", body, headers).body
    "charge" = resp_body.data.payment.action
  end

  def main do
    raj_gh = System.get_env "RAJ_GH_USER"
    raj_venmo = System.get_env "RAJ_VENMO_USER"
    my_venmo = System.get_env "MY_VENMO"
    if get_hours_since_last_commit(raj_gh) > 24 do
      mock = true
      if mock do
        IO.puts "MOCKED CHARGE"
      else
        charge_user(raj_venmo, my_venmo, "You didn't commit in 24 hrs", "5.00")
      end
    end
  end
end
