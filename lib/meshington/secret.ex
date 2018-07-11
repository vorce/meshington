defmodule Meshington.Secret do
  @moduledoc """
  Represent a single secret entry for one user
  """

  defstruct name: "",
            url: "",
            username: "",
            password: "",
            notes: ""

  def new(name, url, username, password, notes \\ "") do
    %__MODULE__{
      name: name,
      url: url,
      username: username,
      password: password,
      notes: notes
    }
  end
end
