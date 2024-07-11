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

<DataTable data={cleaned_docs}/>



```sql tokenized_docs
select 
    tweet_id,
    unnest(string_split(cleaned_text, ' ')) as token
from ${cleaned_docs}
```

## Tokenized Tweets

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

<DataTable data={word_frequency}/>

<BarChart
    title="Word Frequency"
    data={word_frequency.where(`freq > 1 and freq <20`)}
    x=token
    y=freq
    swapXY
/>

