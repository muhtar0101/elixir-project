# lib/lms_web/components/core_components.ex
defmodule LmsWeb.CoreComponents do
  use Phoenix.Component
  import Phoenix.HTML
  import Phoenix.HTML.Form

# ---- SIMPLE FORM ----
attr :for, :any, required: true
attr :action, :string, default: nil   # << қосылды
attr :method, :string, default: nil   # << қосылды
attr :rest, :global
slot :inner_block, required: true

  def simple_form(assigns) do
  ~H"""
  <.form for={@for} action={@action} method={@method} {@rest} class="space-y-4">
    <%= render_slot(@inner_block) %>
  </.form>
  """
end

  # -------- INPUT (textarea) --------
  attr :field, Phoenix.HTML.FormField, required: true
  attr :type, :string, default: "text"
  attr :label, :string, default: nil
  attr :rest, :global

  def input(%{type: "textarea"} = assigns) do
    assigns =
      assign_new(assigns, :value, fn ->
        input_value(assigns.field.form, assigns.field.field)
      end)

    ~H"""
    <div class="space-y-1">
      <%= if @label do %>
        <label for={@field.id} class="block text-sm font-medium"><%= @label %></label>
      <% end %>
      <textarea id={@field.id} name={@field.name} class="w-full border rounded p-2" {@rest}><%= @value %></textarea>
    </div>
    """
  end

  # -------- INPUT (checkbox) --------
  def input(%{type: "checkbox"} = assigns) do
    assigns =
      assign_new(assigns, :checked, fn ->
        !!input_value(assigns.field.form, assigns.field.field)
      end)

    ~H"""
    <label class="inline-flex items-center gap-2">
      <input
        type="checkbox"
        id={@field.id}
        name={@field.name}
        checked={@checked}
        class="border rounded"
        {@rest} />
      <span><%= @label %></span>
    </label>
    """
  end

  # -------- INPUT (text, number, password, т.б.) --------
  def input(assigns) do
    assigns =
      assign_new(assigns, :value, fn ->
        input_value(assigns.field.form, assigns.field.field)
      end)

    ~H"""
    <div class="space-y-1">
      <%= if @label do %>
        <label for={@field.id} class="block text-sm font-medium"><%= @label %></label>
      <% end %>
      <input
        type={@type}
        id={@field.id}
        name={@field.name}
        value={@value}
        class="w-full border rounded p-2"
        {@rest} />
    </div>
    """
  end

  # -------- BUTTON --------
  attr :type, :string, default: "submit"
  attr :rest, :global
  slot :inner_block, required: true

  def button(assigns) do
    ~H"""
    <button type={@type} class="px-4 py-2 rounded-2xl shadow" {@rest}>
      <%= render_slot(@inner_block) %>
    </button>
    """
  end

  # Қарапайым <.header> компоненті
attr :class, :string, default: ""
slot :inner_block, required: true

def header(assigns) do
  ~H"""
  <header class={"mb-6 " <> @class}>
    <h1 class="text-2xl font-semibold leading-tight">
      <%= render_slot(@inner_block) %>
    </h1>
  </header>
  """
end

end
