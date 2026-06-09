import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static get targets() {
    return ['result']
  }
  
  preventEnter(event) {
    if (event.key === "Enter") event.preventDefault()
  }
  
  navigate(event) {
    switch(event.key) {
      case "Enter":
        this.selected.click()
        break
      case "ArrowUp":
        this.selectPrevious()
        break
      case "ArrowDown":
        this.selectNext()
        break
      default:
    }
  }
  
  selectPrevious() {
    if (!this.selected) return 
    let previous = this.selected.previousElementSibling
    if (previous) this.selectResult(previous)
  }
  
  selectNext() {
    if (!this.selected) return 
    let next = this.selected.nextElementSibling
    if (next) this.selectResult(next)
  }
  
  select(event) {
    this.selectResult(event.currentTarget)
  }
  
  selectResult(resultElement) {
    this.deselectAll()
    resultElement.querySelectorAll("[data-selected-class]").forEach(function(el) {
      el.classList.add(el.dataset.selectedClass)
    })
    resultElement.dataset.selected = true
  }
  
  deselectAll() {
    this.resultTargets.forEach(function(result) {
      result.querySelectorAll("[data-selected-class]").forEach(function(el) {
        el.classList.remove(el.dataset.selectedClass)
      })
      result.removeAttribute('data-selected')
    })
  }
  
  get selected() {
    return this.resultTargets.find(result => result.hasAttribute('data-selected'))
  }
  
}