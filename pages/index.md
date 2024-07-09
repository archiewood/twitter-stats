# Twitter Stats

```sql twitter_all_time
select * from twitter
```

```sql twitter_filtered
select * from twitter
where timestamp between '${inputs.range.start}' and '${inputs.range.end}'
```

```sql twitter_filtered_single_metric
select * from twitter
where timestamp between '${inputs.range.start}' and '${inputs.range.end}'
and metric = '${inputs.metric_picker.value}'
```

```sql filtered_totals
select metric, sum(value) as value from ${twitter_filtered} group by metric
```

```sql metrics
select metric from twitter group by metric
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
    title={inputs.metric_picker.value}
  />

{:else if inputs.chart.value == "Line"}

  <LineChart
    data={twitter_filtered_single_metric}
    x=timestamp
    y=value
    title={inputs.metric_picker.value}
  />

{/if}
{#each metrics as row}

  <BigValue
    data={filtered_totals.where(`metric = '${row.metric}'`)}
    value=value
    title={row.metric}
  />

{/each}