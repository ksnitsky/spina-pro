import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static get targets() {
    return [ "title", "titleInput", "description", "descriptionInput", "widthCalculator", "widthResult" ]
  }
  
  connect() {
    this.renderTitle()
    this.renderDescription()
  }
  
  renderTitle() {
    if (this.titleInputTarget.value != "") {
      this.titleTarget.innerText = this.titleInputTarget.value
    } else {
      this.titleTarget.innerText = this.fallbackTitle
    }
  }
  
  renderDescription() {
    if (this.descriptionInputTarget.value != "") {
      this.descriptionTarget.innerText = this.descriptionInputTarget.value 
    } else {
      this.descriptionTarget.innerText = this.fallbackDescription
    }
    
    this.calculateWidth()
  }
  
  calculateWidth() {
    this.widthCalculatorTarget.innerText = this.descriptionInputTarget.value
    this.descriptionTarget.classList.remove('text-red-600', 'text-yellow-600', 'text-gray-700')
    
    if (this.descriptionWidth > this.descriptionDesktopMaximum) {
      this.descriptionTarget.classList.add('text-red-600')
    } else if (this.descriptionWidth > this.descriptionMobileMaximum) {
      this.descriptionTarget.classList.add('text-yellow-600')
    } else {
      this.descriptionTarget.classList.add('text-gray-700')
    }
  }
  
  get fallbackTitle() {
    return this.titleTarget.dataset.fallbackTitle
  }
  
  get fallbackDescription() {
    return this.descriptionTarget.dataset.fallbackDescription
  }
  
  get descriptionWidth() {
    return this.widthCalculatorTarget.offsetWidth
  }
  
  // Max width for desktop
  get descriptionDesktopMaximum() {
    return 920
  }
  
  // Max width for mobile
  get descriptionMobileMaximum() {
    return 680
  }
  
}