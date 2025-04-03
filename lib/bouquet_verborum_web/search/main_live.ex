defmodule BouquetVerborumWeb.Search.MainLive do
  use BouquetVerborumWeb, :live_view
  import Ecto.Query
  import Phoenix.HTML

  @impl true
  def render(assigns) do
    ~H"""
    <.simple_form for={@form} id="search_form" phx-submit="search" phx-change="validate">
      <.input type="text" field={@form[:word]} phx-debounce="300" value={@word} />
    </.simple_form>

    <div class="tabs">
      <button
        class={"tab #{if @active_tab == :lexicon, do: "active"}"}
        phx-click="switch_tab" phx-value-tab="lexicon"
      >
        სიტყვისკონა
      </button>
      <button
        class={"tab #{if @active_tab == :bible, do: "active"}"}
        phx-click="switch_tab" phx-value-tab="bible"
      >
        ბიბლია
      </button>
    </div>

    <div class="tab-content">
      <%= if @active_tab == :lexicon do %>
        <div class="lexicon-results">
          <ul>
            <li :for={{_id, result} <- @streams.lexicon_results} id={"lexicon-#{result.id}"}>
              <strong><%= result.word %></strong>: <%= highlight(result.meaning, get_in(@form || %{}, [:word, :value])) %>
            </li>
          </ul>
        </div>
      <% else %>
        <div class="bible-results">
          <ul>
            <li :for={{_id, result} <- @streams.bible_results} id={"bible-#{result.id}"}>
              <div class="bible-reference">
                <%= result.book %> <%= result.chapter %>:<%= result.paragraph %>
              </div>
              <div class="bible-text">
                <%= highlight(result.text, get_in(@form || %{}, [:word, :value])) %>
              </div>
            </li>
          </ul>
        </div>
      <% end %>
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    changeset = BouquetVerborum.Search.Input.changeset(%BouquetVerborum.Search.Input{}, %{})

    socket =
      socket
      |> assign(trigger_submit: false, check_errors: false, counter: 0, active_tab: :lexicon, word: "")
      |> assign_form(changeset)
      |> stream(:lexicon_results, [])
      |> stream(:bible_results, [])

    {:ok, socket, temporary_assigns: [form: nil]}
  end

  @impl true
  def handle_event("switch_tab", %{"tab" => "lexicon"}, socket) do
    {:noreply, assign(socket, active_tab: :lexicon, word: socket.assigns.word)}
  end

  @impl true
  def handle_event("switch_tab", %{"tab" => "bible"}, socket) do
    {:noreply, assign(socket, active_tab: :bible, word: socket.assigns.word)}
  end

  @impl true
  def handle_event("search", %{"search" => _search_params}, socket) do
    {:noreply, socket |> assign(trigger_submit: true)}
  end

  @impl true
  def handle_event("validate", %{"search" => %{"word" => word}}, socket) do
    if String.length(word) > 1 do
      %{lexicon_results: lexicon, bible_results: bible} = search_word(word)
      socket =
        socket
        |> assign(word: word) # Сохраняем введенное слово
        |> stream(:lexicon_results, lexicon, reset: true)
        |> stream(:bible_results, bible, reset: true)
      {:noreply, socket}
    else
      socket =
        socket
        |> assign(word: word) # Сохраняем введенное слово
        |> stream(:lexicon_results, [], reset: true)
        |> stream(:bible_results, [], reset: true)
      {:noreply, socket}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "search")

    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
  end

  defp highlight(text, term) do
    if term && String.length(term) > 0 do
      text
      |> String.replace(term, "<mark>#{term}</mark>", global: true)
      |> raw()
    else
      text
    end
  end

  defp search_word(word) do
    # Поиск в словаре
    lexicon_results =
      from(
        r in BouquetVerborum.Lexicon,
        where: ilike(r.word, ^"%#{word}%") or ilike(r.meaning, ^"%#{word}%"),
        select: %{id: r.id, word: r.word, meaning: r.meaning, source: :lexicon}
      )
      |> BouquetVerborum.Repo.all()
      |> Enum.map(fn result ->
        %{result | id: "lexicon_#{result.id}"}
      end)

    # Поиск в Библии
    bible_results =
      from(
        b in BouquetVerborum.Bible,
        where: ilike(b.text, ^"%#{word}%"),
        select: %{
          id: b.id,
          text: b.text,
          book: b.book,
          chapter: b.chapter,
          paragraph: b.paragraph,
          source: :bible
        }
      )
      |> BouquetVerborum.Repo.all()
      |> Enum.map(fn result ->
        %{result | id: "bible_#{result.id}"}
      end)

    %{
      lexicon_results: lexicon_results,
      bible_results: bible_results
    }
  end
end
