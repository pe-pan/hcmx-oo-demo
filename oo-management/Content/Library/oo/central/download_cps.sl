namespace: oo.central
flow:
  name: download_cps
  inputs:
    - cp_folder: "c:\\\\temp"
  workflow:
    - get_cps:
        do:
          oo.central.get_cps: []
        publish:
          - cp_ids
          - cps_json
        navigate:
          - FAILURE: on_failure
          - SUCCESS: list_iterator
    - download_cp:
        do:
          oo.central.download_cp:
            - cp_id: '${cp_id}'
            - file_path: "${'%s\\\\%s-%s-cp.jar' % (cp_folder, cp_name, cp_version)}"
        publish:
          - cp_file: '${file_path}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_cp_properties
    - get_name:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${cps_json}'
            - json_path: "${\"$.[?(@.id == '%s')].name\" % cp_id}"
        publish:
          - cp_name: '${return_result[2:-2]}'
        navigate:
          - SUCCESS: get_version
          - FAILURE: on_failure
    - list_iterator:
        do:
          io.cloudslang.base.lists.list_iterator:
            - list: '${cp_ids}'
        publish:
          - cp_id: '${result_string}'
        navigate:
          - HAS_MORE: get_name
          - NO_MORE: SUCCESS
          - FAILURE: on_failure
    - get_version:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${cps_json}'
            - json_path: "${\"$.[?(@.id == '%s')].version\" % cp_id}"
        publish:
          - cp_version: '${return_result[2:-2]}'
        navigate:
          - SUCCESS: download_cp
          - FAILURE: on_failure
    - get_cp_properties:
        do:
          oo.central.get_cp_properties:
            - cp_file: '${cp_file}'
            - cp_folder: '${cp_folder}'
        publish:
          - new_cp_file: "${'%s\\\\%s-%s-cp.jar' % (cp_folder, artifact_id, version)}"
        navigate:
          - SUCCESS: string_equals
          - FAILURE: list_iterator
    - rename_cp:
        do:
          io.cloudslang.base.cmd.run_command:
            - command: "${'move \"%s\" \"%s\"' % (cp_file, new_cp_file)}"
        navigate:
          - SUCCESS: list_iterator
          - FAILURE: on_failure
    - string_equals:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${cp_file}'
            - second_string: '${new_cp_file}'
        navigate:
          - SUCCESS: list_iterator
          - FAILURE: rename_cp
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_cps:
        x: 97
        'y': 121
      download_cp:
        x: 455
        'y': 485
      get_name:
        x: 711
        'y': 263
      list_iterator:
        x: 407
        'y': 121
        navigate:
          3b4c45ed-5fd3-e1e8-c9a4-76e92505981c:
            targetId: a599c753-b1be-e756-fa0a-ce34f8807973
            port: NO_MORE
      get_version:
        x: 649
        'y': 469
      get_cp_properties:
        x: 287
        'y': 488
      rename_cp:
        x: 71
        'y': 262
      string_equals:
        x: 116
        'y': 424
    results:
      SUCCESS:
        a599c753-b1be-e756-fa0a-ce34f8807973:
          x: 720
          'y': 117
