include(RunCMake)

if(RunCMake_GENERATOR STREQUAL "Xcode")
  run_cmake(ConfigNotAllowed)
endif()

run_cmake(EmptyKeywordArgs)
run_cmake(OriginDebug)
run_cmake(CMP0026-LOCATION)
run_cmake(CMP0076-OLD)
run_cmake(CMP0076-WARN)
run_cmake(RelativePathInInterface)
run_cmake(RelativePathInSubdirGenEx)
run_cmake(RelativePathInSubdirInterface)
run_cmake(RelativePathInSubdirPrivate)
run_cmake(RelativePathInSubdirInclude)
run_cmake(ExportBuild)
run_cmake(AddCustomTargetPublicSources)
run_cmake(AddCustomTargetPrivateSources)
run_cmake(AddCustomTargetInterfaceSources)
run_cmake(AddCustomTargetSources)
run_cmake(AddCustomTargetCheckProperty)
run_cmake(AddCustomTargetGenx)

run_cmake(FileSetProperties)
run_cmake(FileSetNoType)
run_cmake(FileSetWrongType)
run_cmake(FileSetDefaultWrongType)
run_cmake(FileSetChangeScope)
run_cmake(FileSetChangeType)
run_cmake(FileSetWrongBaseDirs)
run_cmake(FileSetWrongBaseDirsRelative)
run_cmake(FileSetOverlappingBaseDirs)
run_cmake(FileSetInstallMissingSetsPrivate)
run_cmake(FileSetInstallMissingSetsInterface)
run_cmake(FileSetNoScope)
run_cmake(FileSetNoExistPrivate)
run_cmake(FileSetNoExistInterface)
run_cmake(FileSetNoExistInstall)
run_cmake(FileSetDirectories)
run_cmake(FileSetCustomTarget)

set(RunCMake_TEST_OPTIONS -DCMAKE_POLICY_DEFAULT_CMP0115=NEW)
run_cmake(FileSetFileNoExist)
unset(RunCMake_TEST_OPTIONS)

function(run_export_import name)
  if(RunCMake_GENERATOR_IS_MULTI_CONFIG)
    set(_config_options "-DCMAKE_CONFIGURATION_TYPES=Debug\\\\;Release")
  else()
    set(_config_options -DCMAKE_BUILD_TYPE=Debug)
  endif()

  set(RunCMake_TEST_NO_CLEAN 1)
  set(RunCMake_TEST_BINARY_DIR "${RunCMake_BINARY_DIR}/${name}Export-build")
  set(RunCMake_TEST_OPTIONS "--install-prefix=${RunCMake_TEST_BINARY_DIR}/install" ${_config_options})
  file(REMOVE_RECURSE "${RunCMake_TEST_BINARY_DIR}")
  file(MAKE_DIRECTORY "${RunCMake_TEST_BINARY_DIR}")
  run_cmake(${name}Export)
  run_cmake_command(${name}Export-build ${CMAKE_COMMAND} --build . --config Debug)
  run_cmake_command(${name}Export-build ${CMAKE_COMMAND} --install . --config Debug)
  if(RunCMake_GENERATOR_IS_MULTI_CONFIG)
    run_cmake_command(${name}Export-build ${CMAKE_COMMAND} --build . --config Release)
    run_cmake_command(${name}Export-build ${CMAKE_COMMAND} --install . --config Release)
  endif()
  unset(RunCMake_TEST_OPTIONS)

  set(RunCMake_TEST_BINARY_DIR "${RunCMake_BINARY_DIR}/${name}Import-build")
  unset(RunCMake_TEST_OPTIONS)
  file(REMOVE_RECURSE "${RunCMake_TEST_BINARY_DIR}")
  file(MAKE_DIRECTORY "${RunCMake_TEST_BINARY_DIR}")
  run_cmake(${name}Import)
  run_cmake_command(${name}Import-build ${CMAKE_COMMAND} --build . --config Debug)
  if(RunCMake_GENERATOR_IS_MULTI_CONFIG)
    run_cmake_command(${name}Import-build ${CMAKE_COMMAND} --build . --config Release)
  endif()

  unset(RunCMake_TEST_BINARY_DIR)
  unset(RunCMake_TEST_NO_CLEAN)
endfunction()

run_export_import(FileSet)
