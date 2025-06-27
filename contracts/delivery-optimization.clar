;; Delivery Optimization Contract
;; Optimizes delivery schedules and routes

(define-constant ERR_UNAUTHORIZED (err u400))
(define-constant ERR_ROUTE_NOT_FOUND (err u401))
(define-constant ERR_INVALID_PRIORITY (err u402))
(define-constant ERR_OPTIMIZATION_FAILED (err u403))

;; Priority levels
(define-constant PRIORITY_LOW u1)
(define-constant PRIORITY_MEDIUM u2)
(define-constant PRIORITY_HIGH u3)
(define-constant PRIORITY_URGENT u4)

;; Data structures
(define-map delivery-schedules
  { schedule-id: uint }
  {
    coordinator: principal,
    carrier: principal,
    shipments: (list 10 uint),
    optimized-route: (list 10 (string-ascii 100)),
    total-distance: uint,
    estimated-time: uint,
    priority: uint,
    created-at: uint,
    status: uint
  }
)

(define-map route-optimizations
  { optimization-id: uint }
  {
    original-route: (list 10 (string-ascii 100)),
    optimized-route: (list 10 (string-ascii 100)),
    distance-saved: uint,
    time-saved: uint,
    algorithm-used: (string-ascii 50),
    created-at: uint
  }
)

(define-data-var next-schedule-id uint u1)
(define-data-var next-optimization-id uint u1)

;; Public functions
(define-public (create-delivery-schedule
  (carrier principal)
  (shipments (list 10 uint))
  (route (list 10 (string-ascii 100)))
  (priority uint)
)
  (let ((schedule-id (var-get next-schedule-id)))
    (asserts! (and (>= priority u1) (<= priority u4)) ERR_INVALID_PRIORITY)
    (map-set delivery-schedules
      { schedule-id: schedule-id }
      {
        coordinator: tx-sender,
        carrier: carrier,
        shipments: shipments,
        optimized-route: route,
        total-distance: u0,
        estimated-time: u0,
        priority: priority,
        created-at: block-height,
        status: u1
      }
    )
    (var-set next-schedule-id (+ schedule-id u1))
    (ok schedule-id)
  )
)

(define-public (optimize-route
  (schedule-id uint)
  (original-route (list 10 (string-ascii 100)))
  (optimized-route (list 10 (string-ascii 100)))
  (distance-saved uint)
  (time-saved uint)
)
  (let (
    (schedule (unwrap! (map-get? delivery-schedules { schedule-id: schedule-id }) ERR_ROUTE_NOT_FOUND))
    (optimization-id (var-get next-optimization-id))
  )
    (asserts! (is-eq tx-sender (get coordinator schedule)) ERR_UNAUTHORIZED)

    ;; Update schedule with optimized route
    (map-set delivery-schedules
      { schedule-id: schedule-id }
      (merge schedule {
        optimized-route: optimized-route,
        total-distance: distance-saved,
        estimated-time: time-saved
      })
    )

    ;; Record optimization
    (map-set route-optimizations
      { optimization-id: optimization-id }
      {
        original-route: original-route,
        optimized-route: optimized-route,
        distance-saved: distance-saved,
        time-saved: time-saved,
        algorithm-used: "basic-optimization",
        created-at: block-height
      }
    )

    (var-set next-optimization-id (+ optimization-id u1))
    (ok optimization-id)
  )
)

(define-public (update-schedule-priority (schedule-id uint) (new-priority uint))
  (let ((schedule (unwrap! (map-get? delivery-schedules { schedule-id: schedule-id }) ERR_ROUTE_NOT_FOUND)))
    (asserts! (is-eq tx-sender (get coordinator schedule)) ERR_UNAUTHORIZED)
    (asserts! (and (>= new-priority u1) (<= new-priority u4)) ERR_INVALID_PRIORITY)
    (map-set delivery-schedules
      { schedule-id: schedule-id }
      (merge schedule { priority: new-priority })
    )
    (ok true)
  )
)

;; Read-only functions
(define-read-only (get-delivery-schedule (schedule-id uint))
  (map-get? delivery-schedules { schedule-id: schedule-id })
)

(define-read-only (get-route-optimization (optimization-id uint))
  (map-get? route-optimizations { optimization-id: optimization-id })
)

(define-read-only (calculate-route-efficiency (original-distance uint) (optimized-distance uint))
  (if (> original-distance u0)
    (/ (* (- original-distance optimized-distance) u100) original-distance)
    u0
  )
)

(define-read-only (get-priority-weight (priority uint))
  (if (is-eq priority PRIORITY_URGENT)
    u4
    (if (is-eq priority PRIORITY_HIGH)
      u3
      (if (is-eq priority PRIORITY_MEDIUM)
        u2
        u1
      )
    )
  )
)
