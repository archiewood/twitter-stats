# Twitter Stats

```sql twitter_all_time
select * from metrics
```

```sql twitter_filtered
select * from metrics
where timestamp between '${inputs.range.start}' and '${inputs.range.end}'
```

```sql twitter_filtered_single_metric
select * from metrics
where timestamp between '${inputs.range.start}' and '${inputs.range.end}'
and metric = '${inputs.metric_picker.value}'
```

```sql filtered_totals
select metric, sum(value) as value from ${twitter_filtered} group by metric
```

```sql metrics
select metric from metrics group by metric
```
<Dropdown data={metrics} name=metric_picker value=metric/>
<DateRange name=range data={twitter_all_time} dates=timestamp/>
<Dropdown name=chart>
  <DropdownOption value=Bar/>
  <DropdownOption value=Line/>
</Dropdown>

{#if inputs.chart.value == "Bar"}

  <BarChart
    data={twitter_filtered_single_metric}
    x=timestamp
    y=value
    yFmt=num0
    title={inputs.metric_picker.value}
  />

{:else if inputs.chart.value == "Line"}

  <LineChart
    data={twitter_filtered_single_metric}
    x=timestamp
    y=value
    yFmt=num0
    title={inputs.metric_picker.value}
  />

{/if}
{#each metrics as row}

  <BigValue
    data={filtered_totals.where(`metric = '${row.metric}'`)}
    value=value
    title={row.metric}
    fmt=num0
  />

{/each}

## Ranked Tweets

Click a Tweet for detail

```sql tweets
select 
  left(regexp_replace(text, 'https[^ ]*', ''),150) as text,
  '/' || tweet_id as link,
  *
from tweets 
where created_at is not null
order by likes desc
```

```sql tweets_filtered
select * from ${tweets}
where created_at between '${inputs.range.start}' and '${inputs.range.end}'
```

<DataTable data={tweets_filtered} compact rows=all link=link totalRow>
  <Column id=text/>
  <Column id=likes/>
</DataTable>

{#each tweets as tweet}
<a href={tweet.link} class="hidden"/>
{/each}

