program main
use data_module
use update_position
use compute_acc
use subroutines
implicit none

	!#################data#################!
	integer :: i0, i, j, k	
	!################begin#################!
	call cpu_time(started)
	call random_seed()
	call read_data             								 !Read data from data.txt
	call data_operation												 !some data are processed from data read
	call data_allocate												 !allocate the arrays such as pos
	
	if (restart_or_continue == 0) then
		i=1
		call charge_function
		call initialize_position
		call initialize_velocity
		if (qq/=0) then
			call error_analysis
		end if
		call lj_verlet_list
		call write_pos
		call write_pos1
		call write_vel1(1)
		call write_height(1)
		call compute_force
		call write_acc
		call write_hist
	else if (restart_or_continue /= 0) then
		call charge_function
		call continue_read_data(i)
		if (qq/=0) then
			call error_analysis
		end if
		call lj_verlet_list
		call rescale_velocity
		call compute_force
		call write_pos
		call write_vel
		call write_acc
	end if

	!##############preheating##############!
	if ( i <= StepNum0 ) then										!StepNum0*DeltaStep MCS is preheating steps
		do step=i, StepNum0
			do dstep=1, DeltaStep												!output inteval is DeltaStep MCS
		 		call new_position
				if (mod(dstep,9)==0 .and. step<50) then
					call rescale_velocity
				end if
				if ( dr_max1>(rvl-rcl)/2 ) then
					call lj_verlet_list
					dr_max1=0
				end if
				if ( dr_max2>rsk/2 .and. real_verlet /=0 ) then
					call real_verlet_list
					dr_max2=0
				end if
			end do
			call height
			call write_height(step)
			if (mod(step,10)==0) then
				write(*,*) 'step:', step,'npair1:',npair1,'npair2:',npair2
				call error_analysis
				call write_height(step)
				call write_pos1										 	!save data to avoid breaking off
				call write_vel1(step)
			end if
		end do
		i=step
	end if

	!################running###############!
	do step=i,StepNum0+StepNum						!StepNum*DeltaStep MCS is running steps
		do dstep=1, DeltaStep							!output inteval is DeltaStep MCS
	 		call new_position
			if ( dr_max1>(rvl-rcl)/2 ) then
				call lj_verlet_list
				dr_max1=0
			end if
			if ( dr_max2>rsk/2 .and. real_verlet /=0 ) then
				call real_verlet_list
				dr_max2=0
			end if
			if (mod(dstep,1000)==0) then			!calculate physical quantities at each 200step
				call histogram
			end if
		end do
		call height
		call write_height(step)
		if (mod(step,10)==0) then
			write(*,*) 'step:', step,'npair1:',npair1,'npair2:',npair2
			call write_pos1										!save data to avoid breaking off
			call write_vel1(step)
			call write_hist
		end if
	end do

	!##################end#################!
	call cpu_time(finished)
	total_time=finished-started+total_time
	call write_time(total_time)
	write(*,*) 'finished!'
	
end program





