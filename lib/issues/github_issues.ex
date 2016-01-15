defmodule Issues.GitHubIssues do
  @user_agent [{"User-Agent", "Elixir elixir@lackac.hu"}]

  @github_url Application.get_env(:issues, :github_url)

  def fetch(user, repo) do
    issues_url(user, repo)
      |> HTTPoison.get(@user_agent)
      |> handle_response
  end

  def issues_url(user, repo) do
    "#{@github_url}/repos/#{user}/#{repo}/issues"
  end

  def handle_response({:ok,    %{status_code: 200, body: body}}) do
    {:ok, Poison.Parser.parse!(body)}
  end
  def handle_response({:error, %{status_code: ___, body: body}}) do
    {:error, Poison.Parser.parse!(body)}
  end
end
