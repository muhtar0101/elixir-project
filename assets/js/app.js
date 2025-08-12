// assets/js/app.js — финал нұсқа
import "../css/app.css"
import "phoenix_html"
import { Socket } from "phoenix"
import { LiveSocket } from "phoenix_live_view"

// ---- Бір ғана Hooks объектісі
let Hooks = {}

// Еркін жауап (input/textarea)
Hooks.Answer = {
  mounted() {
    this.el.addEventListener("input", (e) => {
      this.pushEvent("set_answer", { qid: this.el.dataset.q, value: e.target.value })
    })
  }
}

// Радио (бір дұрыс жауап)
Hooks.AnswerRadio = {
  mounted() {
    this.el.addEventListener("change", (e) => {
      this.pushEvent("set_answer", { qid: this.el.dataset.q, value: e.target.value })
    })
  }
}

// Чекбокс (көп дұрыс жауап)
Hooks.AnswerCheckbox = {
  mounted() {
    this.el.addEventListener("change", (_) => {
      const q = this.el.dataset.q
      const boxes = document.querySelectorAll(`input[type=checkbox][data-q="${q}"]`)
      const vals = Array.from(boxes).filter((b) => b.checked).map((b) => b.value)
      this.pushEvent("set_answer", { qid: q, value: vals })
    })
  }
}

// Сәйкестендіру (match)
Hooks.AnswerMatch = {
  mounted() {
    this.el.addEventListener("input", (e) => {
      // MVP: right индексін бір мән ретінде жібереміз
      this.pushEvent("set_answer", {
        qid: this.el.dataset.q,
        value: { [this.el.dataset.right]: e.target.value }
      })
    })
  }
}

// MathJax typeset
Hooks.MathJax = {
  mounted() { this.typeset() },
  updated() { this.typeset() },
  typeset() {
    if (window.MathJax && window.MathJax.typeset) {
      window.MathJax.typeset()
    }
  }
}

// LiveSocket
const csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
const liveSocket = new LiveSocket("/live", Socket, {
  hooks: Hooks,
  params: { _csrf_token: csrfToken }
})

liveSocket.connect()
window.liveSocket = liveSocket
