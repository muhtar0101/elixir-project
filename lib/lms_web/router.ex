# lib/lms_web/router.ex
defmodule LmsWeb.Router do
  use LmsWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {LmsWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    # plug LmsWeb.FetchCurrentUser  # Егер модульді кейін жасасаңыз, осыны ашасыз
  end

  scope "/", LmsWeb do
    pipe_through :browser

    # Ашық беттер (курстар)
    live "/", HomeLive, :index
    live "/courses/:slug", CourseShowLive, :show
    live "/courses/:slug/lesson/:id", LessonShowLive, :show

    # Аутентификация (контроллер экшндарымен сәйкестендірілген)
    get    "/register",  AuthController, :register_form
    post   "/register",  AuthController, :register_post
    get    "/login",     AuthController, :login_form
    post   "/login",     AuthController, :login_post
    delete "/logout",    AuthController, :logout

    # Сатып алу
    post "/purchase/:slug", PurchaseController, :create

    # Менің беттерім (Controller арқылы керек болса)
    get "/me/shelf",    MeController, :shelf
    get "/me/courses",  MeController, :courses
    get "/me/results",  MeController, :results
  end

  # Admin
  scope "/admin", LmsWeb do
    pipe_through :browser
    live "/courses/:id/edit", Admin.CourseEditorLive, :edit
  end

  # LiveView сессиялары -----------------------------------------

  # current_user-ді жүктейтін ашық LV сессия (қажет болса осында LV қосуға болады)
  live_session :default,
    on_mount: [{LmsWeb.UserAuth, :load_current_user}] do
    # мысалы: live "/something", LmsWeb.SomeLive, :index
  end

  # Тек логинмен кіретін LV
  live_session :authed,
    on_mount: [{LmsWeb.UserAuth, :require_authenticated}] do
    # Толық модуль атауларын қолданып, «module … is not available» қателерін болдырмаймыз
    live "/me",      LmsWeb.MeLive, :index
    live "/teacher", LmsWeb.TeacherLive, :index
  end
end
