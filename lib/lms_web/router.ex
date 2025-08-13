defmodule LmsWeb.Router do
  use LmsWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {LmsWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", LmsWeb do
    pipe_through :browser

    # Public pages
    live "/", HomeLive, :index
    live  "/login", LmsWeb.Auth.LoginLive, :index
    live "/courses/:slug", CourseShowLive, :show
    live "/courses/:slug/lesson/:id", LessonShowLive, :show

    # Auth (бір данасы ғана)
    # Осылай қалдырыңыз:
    get  "/login",    AuthController, :login_form
    post "/login",    AuthController, :login
    post  "/login", LmsWeb.AuthController, :create
    get  "/register", AuthController, :register_form
    post "/register", AuthController, :create_user
    get   "/logout", LmsWeb.AuthController, :delete
    delete "/logout", LmsWeb.AuthController, :delete


    # Purchase
    post "/purchase/:slug", PurchaseController, :create

    # LiveView қорғалған беттер (әзірше қарапайым, керек болса plug қойып аламыз)
    live "/me",      LmsWeb.MeLive, :index
    live "/teacher", LmsWeb.TeacherLive, :index
  end

  scope "/admin", LmsWeb do
    pipe_through :browser
    live "/courses/:id/edit", Admin.CourseEditorLive, :edit
  end
end
