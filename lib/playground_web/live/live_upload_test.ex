defmodule PlaygroundWeb.LiveUploadTest do
  use PlaygroundWeb, :live_view

  alias PlaygroundWeb.Components.LiveUploadComponent

  def render(assigns) do
    ~H"""
    <div>
      <.live_component id="live-upload-component" module={LiveUploadComponent} />
    </div>
    """
  end
end
