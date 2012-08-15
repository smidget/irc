require 'irc'

match /(?<everything>.+)/ do
  words = everything.split(/ +/)
  words.each do |word|
    store('kotw:word').zincrby word, 1, nick
  end
end

match /^!kotw +(?<word>.+)$/ do
  scores = store('kotw:word').zrevrange(word, 0, 2, with_scores: true)
  return if scores.nil?
  scores.each do |tuple|
    who, score = tuple
    reply "#{who} has said '#{word}' #{'time'.pluralize(score)}.", false
  end
end