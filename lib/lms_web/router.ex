defmodule LmsWeb.Router do
  use LmsWeb, :router

  import Phoenix.LiveView.Router
  import LmsWeb.UserAuth   # require_authenticated_user/2, require_admin/2, fetch_current_user/2 т.б.

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {LmsWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user   # НАЗАР АУДАРЫҢЫЗ: plug pipeline ішінде осылай шақырылады
  end

  pipeline :admin do
    plug :require_admin
  end

  scope "/", LmsWeb do
    pipe_through :browser

    # Басты бет
    live "/", HomeLive, :index

    # Аутентификация (контроллерлеріңіз бар деп есептеймін)
    get  "/login",     AuthController, :new
    post "/login",     AuthController, :create
    get  "/logout",    AuthController, :delete

    get  "/register",  RegistrationController, :new
    post "/register",  RegistrationController, :create

    # Курстар (LiveView беттеріңізде қолданылып тұр)
    live "/courses/:slug", CourseShowLive, :show
    post "/purchase/:slug", PurchaseController, :create

    # Пайдаланушының өз параметрлері
    live "/settings", SettingsLive, :index
  end

  scope "/admin", LmsWeb do
    pipe_through [:browser, :admin]

    # Админ: Қолданушылар
    live "/users",        Admin.UsersLive, :index
    live "/users/:id/edit", Admin.UserEditLive, :edit

    # Қаласаңыз: Курстар редакторы (кодта сілтеме бар, сондықтан маршрут беріп қояйық)
    live "/courses/:id", Admin.CourseEditorLive, :index

    # Сабақтарды өңдеу сілтемесі кодта бар екен, уақытша плейсхолдер маршрут
    # Егер нақты LiveView кейін жасайтын болсаңыз да, осы маршрут болғаны
    # ~p"/admin/courses/#{@course.id}/lessons/#{l.id}/edit" ескертуін алып тастайды.
    live "/courses/:course_id/lessons/:id/edit", Admin.LessonEditLive, :edit
  end
end
