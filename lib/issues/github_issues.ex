defmodule Issues.GitHubIssues do

  require Logger

  @user_agent [{"User-Agent", "Elixir elixir@lackac.hu"}]

  @github_url Application.get_env(:issues, :github_url)

  def fetch(user, repo) do
    Logger.info "Fetching user #{user}'s repo #{repo}"
    issues_url(user, repo)
      |> HTTPoison.get(@user_agent)
      |> handle_response
  end

  def issues_url(user, repo) do
    "#{@github_url}/repos/#{user}/#{repo}/issues"
  end

  def handle_response({:ok,    %{status_code: 200, body: body}}) do
    Logger.info "Successful response"
    Logger.debug fn -> inspect(body) end
    {:ok, Poison.Parser.parse!(body)}
  end
  def handle_response({:error, %{status_code: status, body: body}}) do
    Logger.error "Error: #{status} returned"
    {:error, Poison.Parser.parse!(body)}
  end
end
