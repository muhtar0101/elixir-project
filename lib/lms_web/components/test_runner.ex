defmodule LmsWeb.Components.TestRunner do
  use LmsWeb, :live_component
  import Ecto.Query
  alias Lms.Repo
  alias Lms.Assess.{Test, Question, Option, MatchPair}

  @impl true
  def update(%{lesson: lesson} = assigns, socket) do
    test = Repo.preload(lesson.test, questions: [:options, :match_pairs])
    {:ok, assign(socket, assigns |> Map.put(:test, test) |> Map.put(:answers, %{}))}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="space-y-6">
      <%= for q <- Enum.sort_by(@test.questions, & &1.position) do %>
        <div class="border rounded-2xl p-4">
          <div class="font-semibold mb-2">Q<%= q.position %>. <%= Phoenix.HTML.raw(LmsWeb.Markdown.to_html(q.prompt_md)) %></div>

          <%= case q.qtype do %>
            <% "open" -> %>
              <input
                id={"q#{q.id}-open"}
                type="text"
                class="w-full border rounded p-2"
                phx-hook="Answer"
                data-q={q.id} />

            <% "single" -> %>
              <%= for o <- q.options do %>
                <label class="flex gap-2 items-center mb-1">
                  <input
                    id={"q#{q.id}-opt-#{o.id}"}
                    type="radio"
                    name={"q#{q.id}"}
                    value={o.id}
                    phx-hook="AnswerRadio"
                    data-q={q.id} />
                  <span><%= o.label %></span>
                </label>
              <% end %>

            <% "multiple" -> %>
              <%= for o <- q.options do %>
                <label class="flex gap-2 items-center mb-1">
                  <input
                    id={"q#{q.id}-chk-#{o.id}"}
                    type="checkbox"
                    value={o.id}
                    phx-hook="AnswerCheckbox"
                    data-q={q.id} />
                  <span><%= o.label %></span>
                </label>
              <% end %>

            <% "match" -> %>
              <div class="grid md:grid-cols-2 gap-3">
                <div>
                  <%= for {p, i} <- Enum.with_index(q.match_pairs, 1) do %>
                    <div class="mb-2" id={"q#{q.id}-L#{i}"}>L<%= i %>: <%= p.left_text %></div>
                  <% end %>
                </div>
                <div>
                  <%= for {p, i} <- Enum.with_index(q.match_pairs, 1) do %>
                    <div class="mb-2">
                      R<%= i %>: <%= p.right_text %> →
                      <input
                        id={"q#{q.id}-match-R#{i}"}
                        type="number"
                        min="1"
                        class="w-20 border rounded p-1"
                        phx-hook="AnswerMatch"
                        data-q={q.id}
                        data-right={i} />
                    </div>
                  <% end %>
                </div>
              </div>
          <% end %>
        </div>
      <% end %>

      <button phx-click="submit" phx-target={@myself} class="px-4 py-2 rounded-2xl shadow">Жіберу</button>
      <%= if @score do %>
        <div class="p-3 rounded bg-green-50">Нәтиже: <%= @score %>/<%= @max %></div>
      <% end %>
    </div>
    """
  end

  @impl true
  def handle_event("submit", _params, socket) do
    %{test: test} = socket.assigns
    answers = socket.assigns[:answers] || %{}
    {score, max} = grade(test, answers)
    {:noreply, assign(socket, score: score, max: max)}
  end

  # JS Hook-тардан жауап жинау
  @impl true
  def handle_event("set_answer", %{"qid" => qid, "value" => value}, socket) do
    qid = if is_integer(qid), do: qid, else: String.to_integer("#{qid}")
    answers = Map.put(socket.assigns[:answers] || %{}, qid, value)
    {:noreply, assign(socket, answers: answers)}
  end

  # Бағалау (қысқа MVP)
  defp grade(test, answers) do
    qs = Enum.sort_by(test.questions, & &1.position)
    Enum.reduce(qs, {0, length(qs)}, fn q, {acc, max} ->
      ok? =
        case q.qtype do
          "open" ->
            false
          "single" ->
            chosen = answers[q.id]
            correct_id = Enum.find_value(q.options, &(&1.correct && &1.id))
            chosen && "#{chosen}" == "#{correct_id}"
          "multiple" ->
            chosen = MapSet.new(List.wrap(answers[q.id] || []))
            correct = MapSet.new(for o <- q.options, o.correct, do: o.id)
            chosen == correct
          "match" ->
            false
        end

      {acc + if(ok?, do: 1, else: 0), max}
    end)
  end
end
