;; Carrier Coordination Contract
;; Coordinates transportation carriers and their capabilities

(define-constant ERR_UNAUTHORIZED (err u300))
(define-constant ERR_CARRIER_NOT_FOUND (err u301))
(define-constant ERR_ALREADY_REGISTERED (err u302))
(define-constant ERR_INVALID_CAPACITY (err u303))

;; Data structures
(define-map carriers
  { carrier: principal }
  {
    name: (string-ascii 100),
    vehicle-type: (string-ascii 50),
    max-capacity: uint,
    current-load: uint,
    available: bool,
    location: (string-ascii 100),
    rating: uint,
    registered-at: uint
  }
)

(define-map carrier-routes
  { carrier: principal, route-id: uint }
  {
    origin: (string-ascii 100),
    destination: (string-ascii 100),
    estimated-time: uint,
    cost-per-unit: uint,
    active: bool
  }
)

(define-map carrier-assignments
  { carrier: principal, assignment-id: uint }
  {
    shipment-id: uint,
    assigned-at: uint,
    estimated-completion: uint,
    status: uint
  }
)

(define-data-var next-route-id uint u1)
(define-data-var next-assignment-id uint u1)

;; Public functions
(define-public (register-carrier
  (name (string-ascii 100))
  (vehicle-type (string-ascii 50))
  (max-capacity uint)
  (location (string-ascii 100))
)
  (let ((carrier tx-sender))
    (asserts! (is-none (map-get? carriers { carrier: carrier })) ERR_ALREADY_REGISTERED)
    (asserts! (> max-capacity u0) ERR_INVALID_CAPACITY)
    (map-set carriers
      { carrier: carrier }
      {
        name: name,
        vehicle-type: vehicle-type,
        max-capacity: max-capacity,
        current-load: u0,
        available: true,
        location: location,
        rating: u5,
        registered-at: block-height
      }
    )
    (ok true)
  )
)

(define-public (add-route
  (origin (string-ascii 100))
  (destination (string-ascii 100))
  (estimated-time uint)
  (cost-per-unit uint)
)
  (let (
    (carrier tx-sender)
    (route-id (var-get next-route-id))
  )
    (asserts! (is-some (map-get? carriers { carrier: carrier })) ERR_CARRIER_NOT_FOUND)
    (map-set carrier-routes
      { carrier: carrier, route-id: route-id }
      {
        origin: origin,
        destination: destination,
        estimated-time: estimated-time,
        cost-per-unit: cost-per-unit,
        active: true
      }
    )
    (var-set next-route-id (+ route-id u1))
    (ok route-id)
  )
)

(define-public (update-availability (available bool))
  (let ((carrier tx-sender))
    (asserts! (is-some (map-get? carriers { carrier: carrier })) ERR_CARRIER_NOT_FOUND)
    (map-set carriers
      { carrier: carrier }
      (merge
        (unwrap-panic (map-get? carriers { carrier: carrier }))
        { available: available }
      )
    )
    (ok true)
  )
)

(define-public (update-location (new-location (string-ascii 100)))
  (let ((carrier tx-sender))
    (asserts! (is-some (map-get? carriers { carrier: carrier })) ERR_CARRIER_NOT_FOUND)
    (map-set carriers
      { carrier: carrier }
      (merge
        (unwrap-panic (map-get? carriers { carrier: carrier }))
        { location: new-location }
      )
    )
    (ok true)
  )
)

;; Read-only functions
(define-read-only (get-carrier-info (carrier principal))
  (map-get? carriers { carrier: carrier })
)

(define-read-only (get-carrier-route (carrier principal) (route-id uint))
  (map-get? carrier-routes { carrier: carrier, route-id: route-id })
)

(define-read-only (is-carrier-available (carrier principal))
  (match (map-get? carriers { carrier: carrier })
    carrier-data (get available carrier-data)
    false
  )
)

(define-read-only (get-carrier-capacity (carrier principal))
  (match (map-get? carriers { carrier: carrier })
    carrier-data (- (get max-capacity carrier-data) (get current-load carrier-data))
    u0
  )
)
