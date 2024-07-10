with entries as (
  select
      unnest(data.user_result_by_rest_id.result.profile_timeline.timeline.instructions).entries as entries_arr
    from 'sources/needful_things/Content*.json'
  )
  select
    -- Wed Jul 10 02:31:22 +0000 2024	is time format to read
    unnest(entries_arr).entry_id as tweet_id,
    strptime(unnest(entries_arr).content.content.tweet_results.result.legacy.created_at, '%a %b %d %H:%M:%S %z %Y') as created_at,
    unnest(entries_arr).content.content.tweet_results.result.legacy.full_text as text,
    unnest(entries_arr).content.content.tweet_results.result.legacy.bookmark_count as bookmarks,
    unnest(entries_arr).content.content.tweet_results.result.legacy.favorite_count as likes,
    unnest(entries_arr).content.content.tweet_results.result.legacy.quote_count as quotes,
    unnest(entries_arr).content.content.tweet_results.result.views.count::int as views,
    unnest(entries_arr).content.content.tweet_results.result.legacy.entities.media[1].type as media_type,
    unnest(entries_arr).content.content.tweet_results.result.legacy.entities.media[1].media_url_https as img,
  from entries