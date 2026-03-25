# Flutter Performance Optimization

This project demonstrates how to efficiently handle and render a large list of 5000+ products in Flutter while maintaining smooth scrolling performance.

---

## Objective

The goal of this task is to improve UI performance when dealing with large datasets by applying:

* Efficient list rendering techniques
* Caching strategies
* Pagination for scalability
* Performance measurement and analysis

---

## Approach

### 1. Lazy Rendering

Instead of rendering all items at once, `ListView.builder()` is used to build only the widgets that are visible on the screen. This significantly reduces the initial load time and memory usage.

### 2. Pagination (Infinite Scrolling)

To make the solution scalable, data is loaded in smaller chunks (20 items per request). As the user scrolls near the bottom of the list, additional data is fetched automatically. This avoids loading all 5000 items upfront.

### 3. Caching Techniques

* `AutomaticKeepAliveClientMixin` is used to retain the state of list items when they go off-screen
* `RepaintBoundary` helps isolate repaint areas and reduces unnecessary redraws
* `ValueKey` ensures proper widget reuse and avoids unwanted rebuilds

### 4. UI Optimization

* A lightweight widget structure is used (`ListTile`)
* Items are wrapped in simple card-like containers for better readability
* `const` constructors are used wherever possible to minimize rebuilds

---

## Performance Optimization Techniques

| Technique        | Purpose                      |
| ---------------- | ---------------------------- |
| ListView.builder | Builds items lazily          |
| Pagination       | Loads data in smaller chunks |
| RepaintBoundary  | Limits repaint scope         |
| KeepAliveMixin   | Retains widget state         |
| ValueKey         | Improves widget reuse        |
| cacheExtent      | Preloads nearby list items   |

---

## Performance Benchmark

### Before Optimization

The initial implementation used a regular `ListView` with all items rendered at once.

| Metric     | Observation      |
| ---------- | ---------------- |
| FPS        | 20–30 fps        |
| Frame Time | 25–40 ms         |
| Jank       | Noticeable       |
| Memory     | High usage       |
| Load Time  | Around 2 seconds |

---

### After Optimization

With lazy loading and pagination applied:

| Metric     | Observation  |
| ---------- | ------------ |
| FPS        | 60+ fps      |
| Frame Time | ~16 ms       |
| Jank       | Not observed |
| Memory     | Optimized    |
| Load Time  | Under 300 ms |

---

## Tools Used for Measurement

* Flutter DevTools (Performance tab)
* Profile mode (`flutter run --profile`)
* Performance overlay for UI and GPU monitoring

---

## Project Structure

```
lib/
├── models/
├── data/
├── viewmodels/
├── screens/
└── widgets/
```

---

## How to Run

```bash
flutter pub get
flutter run
```

---

## Summary

By switching to lazy rendering and introducing pagination, the application is able to handle large datasets smoothly. The improvements significantly reduce memory usage and eliminate frame drops, resulting in a consistent and responsive user experience.
