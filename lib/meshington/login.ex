defmodule Meshington.Login do
  defstruct name: "",
            url: "",
            username: "",
            password: ""

  def new(name, url, username, password) do
    %__MODULE__{
      name: name,
      url: url,
      username: username,
      password: password
    }
  end
end
