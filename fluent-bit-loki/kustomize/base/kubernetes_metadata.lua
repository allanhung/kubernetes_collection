function kubernetes_metadata(tag, timestamp, record)
  if record['kubernetes'] == nil then
    local result = { }
    for str in string.gmatch(tag, "([^.]+)") do
      table.insert(result, str)
    end  
    new_record = record
    new_record['kubernetes'] = { }
    new_record["kubernetes"]["namespace_name"] = result[2]
    new_record["kubernetes"]["container_name"] = result[3]
    new_record["kubernetes"]["pod_name"] = result[4]
    return 2, 0, new_record
  else
    return 0, 0, 0
  end
end
