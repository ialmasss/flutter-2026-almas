# Practice 10 Notes

## Level 1: Event Loop Order

### Predicted Order
A
C
fetchStudents #1
6 students
B

### Actual Order
A
C
fetchStudents #1
B
6 students

*(Примечание: A и C выводятся мгновенно. Спустя 2 секунды Event Loop последовательно выполняет события из очереди: сначала таймер B, затем результат fetchStudents).*

---

## Level 2: Mounted Guard

### Error when deleting `if (!mounted) return;`
`E/flutter: FlutterError: setState() called after dispose(): _StudentsScreenState#12345(lifecycle state: defunct, not mounted)`

---

## Level 4: Countdown Observations

### Without `_sub.cancel()` in Version B
При закрытии экрана кнопкой Back на `tick 7` в консоль выводится ошибка `setState() called after dispose()`, а генератор продолжает работать в фоновом режиме: `tick 6`, `tick 5` ... до `tick 0`. Это приводит к утечке ресурсов (memory leak).

### With `_sub.cancel()` in Version B
При закрытии экрана на `tick 7` метод `dispose()` вызывает `_sub.cancel()`. Подписка отменяется, генератор останавливается на следующем `await`, и тики в консоли прекращаются.

### Version A (StreamBuilder)
`StreamBuilder` автоматически отменяет подписку на поток (`StreamSubscription`) при удалении виджета из дерева (unmount). При нажатии Back тики прекращаются автоматически.

---

## Level 5: Un-awaited Save Error

### Sentence observation
The user saw a success screen because `Navigator.pop(context)` was executed synchronously before `_api.save()` finished, while the console registered an `Unhandled Exception: Bad state: server rejected 6` a second later.