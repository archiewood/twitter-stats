# Tweet at <Value data={tweets} column=created_at fmt="YYYY-MM-DD HH:MM:SS"/>


```sql tweets
select 
    regexp_replace(text, 'https[^ ]*', '') as text_clean,
    * 
from tweets 
where tweet_id = '${params.tweet_id}'
```

{#each tweets as tweet}

> {tweet.text_clean}

{#if tweet.media_type}

<img src={tweet.img} class="h-72 rounded"/>

{/if}

<BigValue data={tweet} value=views fmt=num0 />
<BigValue data={tweet} value=likes fmt=num0 />
<BigValue data={tweet} value=bookmarks fmt=num0 />
<BigValue data={tweet} value=quotes fmt=num0 />

{/each}

