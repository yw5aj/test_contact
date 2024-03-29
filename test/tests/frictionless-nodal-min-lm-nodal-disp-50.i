starting_point = 2e-1
offset = 1e-2

[GlobalParams]
  displacements = 'disp_x disp_y'
  diffusivity = 1e0
  scaling = 1e0
[]

[Mesh]
  file = long-bottom-block-1elem-blocks.e
[]

[Problem]
  kernel_coverage_check = false
[]

[Variables]
  [./disp_x]
    block = '1 2'
  [../]
  [./disp_y]
    block = '1 2'
  [../]
  [./normal_lm]
    block = 3
  [../]
[]

[ICs]
  [./disp_y]
    block = 2
    variable = disp_y
    value = ${fparse starting_point + offset}
    type = ConstantIC
  [../]
[]

[Kernels]
  [./disp_x]
    type = MatDiffusion
    variable = disp_x
  [../]
  [./disp_y]
    type = MatDiffusion
    variable = disp_y
  [../]
[]


[Constraints]
  [./lm]
    type = NormalNodalLMMechanicalContact
    slave = 10
    master = 20
    variable = normal_lm
    master_variable = disp_x
    disp_y = disp_y
  [../]
  [./disp_x]
    type = NormalNodalMechanicalContact
    slave = 10
    master = 20
    variable = disp_x
    master_variable = disp_x
    lambda = normal_lm
    component = x
  [../]
  [./disp_y]
    type = NormalNodalMechanicalContact
    slave = 10
    master = 20
    variable = disp_y
    master_variable = disp_y
    lambda = normal_lm
    component = y
  [../]
[]

[BCs]
  [./botx]
    type = DirichletBC
    variable = disp_x
    boundary = 40
    value = 0.0
  [../]
  [./boty]
    type = DirichletBC
    variable = disp_y
    boundary = 40
    value = 0.0
  [../]
  [./topy]
    type = FunctionDirichletBC
    variable = disp_y
    boundary = 30
    function = '${starting_point} * cos(2 * pi / 40 * t) + ${offset}'
  [../]
  [./leftx]
    type = FunctionDirichletBC
    variable = disp_x
    boundary = 50
    function = '1e-2 * t'
  [../]
[]

[Executioner]
  type = Transient
  end_time = 50
  dt = 5
  dtmin = .1
  solve_type = 'PJFNK'
  petsc_options = '-snes_converged_reason -ksp_converged_reason -pc_svd_monitor -snes_linesearch_monitor'
  petsc_options_iname = '-pc_type -pc_factor_shift_type -pc_factor_shift_amount -mat_mffd_err'
  petsc_options_value = 'lu       NONZERO               1e-15                   1e-5'
  l_max_its = 30
  nl_max_its = 20
  line_search = 'none'
[]

[Debug]
  show_var_residual_norms = true
[]

[Outputs]
  exodus = true
  [dof]
    type = DOFMap
    execute_on = 'initial'
  []
[]

[Preconditioning]
  [./smp]
    type = SMP
    full = true
  [../]
[]

[Postprocessors]
  active = 'num_nl cumulative contact'
  [./num_nl]
    type = NumNonlinearIterations
  [../]
  [./cumulative]
    type = CumulativeValuePostprocessor
    postprocessor = num_nl
  [../]
  [contact]
    type = ContactDOFSetSize
    variable = normal_lm
    subdomain = '3'
    execute_on = 'nonlinear timestep_end'
  []
[]
