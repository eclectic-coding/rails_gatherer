class Task {
  static swapTasks(first, second) {
    second.detach()
    second.insertBefore(first)
  }

  constructor(anchor) {
    this.$anchor = $(anchor)
    this.$rowElement = this.$anchor.parents("tr")
  }

  previous() {
    return $(this.$rowElement.prev())
  }

  next() {
    return $(this.$rowElement.next())
  }

  onUpClick() {
    if (this.previous().length === 0) {
      return
    }
    Task.swapTasks(this.previous(), this.$rowElement)
    this.updateServer("up")
  }

  onDownClick() {
    if (this.next().length === 0) {
      return
    }
    Task.swapTasks(this.$rowElement, this.next())
    this.updateServer("down")
  }

  taskId() {
    return this.$rowElement.data("taskId")
  }

  updateServer(upOrDown) {
    const url = `/tasks/${this.taskId()}/${upOrDown}.json`
    $.ajax({
      url,
      beforeSend: xhr => {
        xhr.setRequestHeader(
          "X-CSRF-Token",
          $('meta[name="csrf-token"]').attr("content")
        )
      },
      data: { _method: "PATCH" },
      type: "POST"
    })
  }
}

$(() => {
  $(document).on("click", ".up-button", event => {
    new Task(event.target).onUpClick()
  })

  $(document).on("click", ".down-button", event => {
    new Task(event.target).onDownClick()
  })
})
