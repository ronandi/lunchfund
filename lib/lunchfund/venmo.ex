defmodule Venmo do
  use HTTPotion.Base

  def process_url(url) do
    "https://sandbox-api.venmo.com/v1/" <> url
  end

  def process_request_headers(headers) do
    Dict.put headers, :"User-Agent", "github-potion"
  end

  def process_response_body(body) do
    json = JSX.decode(to_string(body), [{:labels, :atom}])
  end

end
