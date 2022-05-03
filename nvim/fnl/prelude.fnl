(module prelude
  {require {core aniseed.core}})

(defn range [lo hi]
  "Eagerly returns a list of numbers from lo to hi, inclusive"
  (if (= lo hi)
    [lo]
    (core.concat [lo] (range (core.inc lo) hi))))

(local charset
    (core.map
    (fn [x]
      (string.char x))
    (core.concat
      (range 48 57)
      (range 75 90)
      (range 97 122))))

(defn reverse [xs]
  "Eagerly reverse the elements of a list"
  (when (not (core.empty? xs))
    (core.concat [(core.last xs)]
                 (reverse (core.butlast xs)))))

(defn take [xs n]
  "Eagerly construct a new list of up to the first n elements of a provided list"
  (when (and (> n 0)
             (not (core.empty? xs)))
    (core.concat [(core.first xs)]
                  (take (core.rest xs) (core.dec n)))))

(defn take-while [xs pred]
  "Eagerly constructs a list of all elements of xs until (pred x) returns true"
  (let [x  (core.first xs)
        xs (core.rest xs)]
    (when (pred x)
      (core.concat [x]
                   (take-while xs pred)))))

(defn rand-str [len]
  "Generates a random alphanumeric string of the specified length"
  (if (= 0 len)
    ""
    (.. (. charset (math.random 1 (length charset)))
        (rand-str (core.dec len)))))

{: range
 : reverse
 : take
 : take-while
 : rand-str}
