(module dotfiles.startify
  {require {core aniseed.core
            nvim aniseed.nvim}})

(defn- startify-quote [author ...]
  [... "" (.. "- " author)])

(set nvim.g.startify_custom_header_quotes [
  ["prototype before polishing. get it working before optimizing it."]
  ["separate policy from mechanism, separate interfaces from engines."]
  ["write simple modular parts connected by clean interfaces."]
  ["design programs to be connected to other programs."]
  ["write programs to write programs when you can."]
  ["design for the future, because it will be here sooner than you think."]
  ["in interface design, always do the least surprising thing."]
  ["when a program has nothing surprising to say, it should say nothing."]
  ["when a program must fail, it should fail noisily and as soon as possible."]
  ["write big programs only when it is clear by demonstration that nothing else will do."]
  ["consider how you would solve your immediate problem without adding anything new."]
  (startify-quote "ludwig wittgenstein" "the world is the totality of facts, not of things.")
  (startify-quote "steve jobs" "would you rather be surfing on the front endge of a wave, or dog-paddling watching it break in front of you?")
  (startify-quote "roberto bolano" "reading is always more important than writing." "test")
  (startify-quote "lao tzu" "we shape clay into a pot." "but it is the emptiness inside" "that holds whatever we want.")
  (startify-quote "doug mcilroy" "design and build software, even operating systems, to be tried early, ideally within weeks." "don't hesitate to throw away the clumsy parts and rebuild them.")
  (startify-quote
    "richard feynman"
    "when you're thinking about something that you don't understand, you have a terrible, uncomfortable feeling called confusion..."
    "now, the confusion's because we're all some kind of apes that are kind of stupid working against this,"
    "trying to figure out [how] to put the two sticks together to reach the banana and we can't quite make it..."
    "so i always feel stupid. once in a while, though, the sticks go together on me and i reach the banana.")
])
