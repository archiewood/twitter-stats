---
title: Twitter Stats
---

```sql twitter_all_time
select * from twitter
```

```sql twitter_filtered
select * from twitter
where timestamp between '${inputs.range.start}' and '${inputs.range.end}'
```

```sql filtered_totals
select metric, sum(value) as value from ${twitter_filtered} group by metric
```

```sql metrics
select metric from twitter group by metric
```

<DateRange name=range data={twitter_all_time} dates=timestamp/>

<br>

{#each metrics as row}

<BigValue
  data={filtered_totals.where(`metric = '${row.metric}'`)}
  value=value
  title={row.metric}
/>

{/each}


<Grid cols=2>

{#each metrics as row}

<LineChart
  data={twitter_filtered.where(`metric = '${row.metric}'`)}
  x=timestamp
  y=value
  title={row.metric}
/>

{/each}

</Grid>




