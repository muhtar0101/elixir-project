def render(assigns) do
  ~H"""
  <div class="mx-auto max-w-md p-6">
    <h1 class="text-2xl font-semibold mb-4">Кіру</h1>

    <!-- Маңызды: CSRF токен міндетті -->
    <form action={~p"/login"} method="post" class="space-y-3">
      <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />

      <div class="flex flex-col gap-1">
        <label class="text-sm font-medium">Email немесе Login</label>
        <input name="user[identifier]" type="text" class="border rounded-md p-2" required />
      </div>

      <div class="flex flex-col gap-1">
        <label class="text-sm font-medium">Пароль</label>
        <input name="user[password]" type="password" class="border rounded-md p-2" required />
      </div>

      <button class="mt-2 px-4 py-2 rounded-md bg-blue-600 text-white">Кіру</button>
    </form>
  </div>
  """
end
