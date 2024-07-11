---
title: NLP
---


```sql cleaned_docs
select 
    tweet_id,
    regexp_replace(regexp_replace(text, '\n', ' ', 'g'), 'https[^\\s]+', '', 'g') as cleaned_text
from tweets
where text is not null
```

## Cleaned Tweets

First we take the tweets and clean them up by removing newlines and URLs.

<DataTable data={cleaned_docs}/>

```sql tokenized_docs
select 
    tweet_id,
    unnest(string_split(cleaned_text, ' ')) as token
from ${cleaned_docs}
```

## Tokenized Tweets

Then we "tokenize" the cleaned tweets by splitting them on spaces, creating one row per token (word).
<DataTable data={tokenized_docs}/>

```sql filtered_tokens
select 
    tweet_id, 
    regexp_replace(lower(token), '[^a-z]', '', 'g') as token -- lowercase and remove non-alphabetic chars
from ${tokenized_docs}
where 
    length(token) > 1
    and token not in (select word from stop_words)
    and token is not null
```

### Filtered Tokens

Remove non-alphabetic characters, lowercase the tokens, and remove stop words.

<DataTable data={filtered_tokens}/>

```sql word_frequency
select 
    --tweet_id, 
    token,
    count(*) as freq
from ${filtered_tokens}
where token is not null
group by all
order by freq desc
```

## Word Frequency

Calculate the frequency of each word in all the tweets.

<DataTable data={word_frequency}/>

<BarChart
    title="Word Frequency"
    data={word_frequency.where(`freq > 1 and freq <20`)}
    x=token
    y=freq
    swapXY
/>


```sql word_frequency_by_tweet
select 
    tweet_id, 
    token,
    count(*) as freq
from ${filtered_tokens}
where token is not null
group by all
order by freq desc
```

## Bag of Words

```sql bag_of_words
pivot ${word_frequency_by_tweet}
on token 
using sum(freq)
```

The "Bag of Words" is a matrix where each row is a tweet and each column is a word. The value in each cell is the frequency of that word in that tweet.

It's a very sparse matrix, as most words don't appear in most tweets.

<DataTable data={bag_of_words} compact/>
