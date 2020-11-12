
@if (Session::has('success'))

<div class="card bg-success">
    <div class="card-header">
    <h3 class="card-title">{{ Session::get('success') }}</h3>

      <div class="card-tools">
        <button type="button" class="btn btn-tool" data-card-widget="remove"><i class="fas fa-times"></i>
        </button>
      </div>
      <!-- /.card-tools -->
    </div>
    <!-- /.card-header -->
  </div>
    
@endif

@if (Session::has('fail'))

<div class="card bg-gradient-danger">
    <div class="card-header">
    <h3 class="card-title">{{ Session::get('fail') }}</h3>

      <div class="card-tools">
        <button type="button" class="btn btn-tool" data-card-widget="remove"><i class="fas fa-times"></i>
        </button>
      </div>
      <!-- /.card-tools -->
    </div>
    <!-- /.card-header -->
  </div>
    
@endif

@if ($errors->count() > 0)
    @foreach ($errors->all() as $error)
        {{$error}}
    @endforeach
@endif