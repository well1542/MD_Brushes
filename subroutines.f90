module subroutines
use data_module
implicit none 
contains
	
	 
!################rij_and_rr#################!	
subroutine rij_and_rr(rij, rsqr, i, j)
	!-----------------------------------------!
	!compute displacement vector and displacement of two particles
	!input : post(pos or pos1), i, j(particle number) 
	!output: rij(displacement vecter), rr(square of displacement)
	!External Variant: Lz(used in period condition)
	!note: including period condition
	!-----------------------------------------!
	implicit none

	real*8, dimension(3), intent(out) :: rij
	real*8, intent(out) :: rsqr
	integer, intent(in) :: i
	integer, intent(in) :: j

	rij=pos(i,1:3)-pos(j,1:3)
	if (rij(1)>Lx/2) then
		rij(1)=rij(1)-Lx
	elseif(rij(1)<=-Lx/2) then
		rij(1)=rij(1)+Lx
	end if
	if (rij(2)>Ly/2) then
		rij(2)=rij(2)-Ly
	elseif(rij(2)<=-Ly/2) then
		rij(2)=rij(2)+Ly
	end if
! 	rij(1)=rij(1)-floor(rij(1)/Lx+0.5)*Lx
! 	rij(2)=rij(2)-floor(rij(2)/Ly+0.5)*Ly
	rsqr=rij(1)*rij(1)+rij(2)*rij(2)+rij(3)*rij(3)
end subroutine rij_and_rr
!##########################################!


!#############period_condition#############!
subroutine period_condition
	!----------------------------------------!
	!input: pos
	!output: pos
	!External Variables: Lx, Lz, NN, Nrod
	!----------------------------------------!
	implicit none
	integer k
	
	do k=1, NN
		if (pos(k,1)>Lx/2) then
			pos(k,1)=pos(k,1)-Lx
		elseif(pos(k,1)<=-Lx/2) then
			pos(k,1)=pos(k,1)+Lx
		end if
		if (pos(k,2)>Ly/2) then
			pos(k,2)=pos(k,2)-Ly
		elseif(pos(k,2)<=-Ly/2) then
			pos(k,2)=pos(k,2)+Ly
		end if
! 		pos(k,1)=pos(k,1)-floor((pos(k,1)+Lx/2)/Lx)*Lx
! 		pos(k,2)=pos(k,2)-floor((pos(k,2)+Ly/2)/Ly)*Ly
	end do
end subroutine period_condition
!##########################################!


!################gauss_dist###############!
subroutine gauss_dist(mu, sigma, rnd)
	!---------------------------------------!
	!
	!---------------------------------------!
	implicit none
	real*8, intent(out) :: rnd
	real*8, intent(in) :: mu, sigma
	real*8 rnd1, rnd2
	
	call random_number(rnd1)
	call random_number(rnd2)
	rnd=sqrt(-2*log(rnd1))*cos(2*pi*rnd2)
	rnd=mu+rnd*sigma
end subroutine gauss_dist
!##########################################!


!############continue_read_data############!
subroutine continue_read_data(l)
	!----------------------------------------!
	!write position to pos.txt
	!input: pos
	!External Variants: NN
	!----------------------------------------!
	integer, intent(out) :: l
	integer :: i,j
	real*8, dimension(SizeHist,10):: phi
	real*8, dimension(SizeHist,8):: theta
	real*8, dimension(2*Nma,4):: force
	real*8, dimension(SizeHist,4):: force1
	real*8, dimension(SizeHist,4):: delta_angle
	
	open(20,file='./data/pos1.txt')
	open(21,file='./data/vel1.txt')
		read(20,*) ((pos(i,j),j=1,4),i=1,NN)
		read(21,*) ((vel(i,j),j=1,3),i=1,NN)
	close(20)
	close(21)
	open(19,file='./start_time.txt')
		read(19,*)
		read(19,*) l
		read(19,*) total_time
		l=l+1
	close(19)
	
	phi=0
	theta=0
	force=0
	delta_angle=0
	open(20,file='./data/phi.txt')
	open(21,file='./data/theta.txt')
	open(22,file='./data/force_liear.txt')
	open(23,file='./data/force_star.txt')
	open(24,file='./data/delta_angle.txt')
	open(25,file='./data/force_liear1.txt')
	open(26,file='./data/force_star1.txt')
		read(20,*) ((phi(i,j),j=1,10),i=1,SizeHist)
			phi_tot(:,2)=phi(:,2)
			phi_l(:,2)=phi(:,3)
			phi_le(:,2)=phi(:,4)
			phi_s(:,2)=phi(:,5)
			phi_sb(:,2)=phi(:,6)
			phi_se(:,2)=phi(:,7)
			phi_a(:,2)=phi(:,8)
			phi_i(:,2)=phi(:,9)
			phi_q(:,2)=phi(:,10)
		read(21,*) ((theta(i,j),j=1,8),i=1,SizeHist)
			theta_l(:,2)=theta(:,2)
			theta_lz(:,2)=theta(:,3)
			theta_ssl(:,2)=theta(:,4)
			theta_sslz(:,2)=theta(:,5)
			theta_sbl(:,2)=theta(:,6)
			theta_sblz(:,2)=theta(:,7)
			theta_bez(:,2)=theta(:,8)
		read(22,*) ((force_l(i,j),j=1,2),i=1,Nml-1)
		read(23,*) ((force(i,j),j=1,4),i=1,2*Nma)
			force_sy(:,2)=force(:,2)
			force_sn(:,2)=force(:,3)
			force_so(:,2)=force(:,4)
		read(25,*) ((force_l1(i,j),j=1,2),i=1,SizeHist)
		read(26,*) ((force1(i,j),j=1,4),i=1,SizeHist)
			force_sy1(:,2)=force1(:,2)
			force_sn1(:,2)=force1(:,3)
			force_so1(:,2)=force1(:,4)
		read(24,*) ((delta_angle(i,j),j=1,4),i=1,SizeHist)
			delta_angle1(:,2)=delta_angle(:,2)
			delta_angle2(:,2)=delta_angle(:,3)
			delta_angle3(:,2)=delta_angle(:,4)
	close(26)
	close(25)
	close(24)
	close(23)
	close(22)
	close(21)
	close(20)
	open(21,file='./data/phi_2d11.txt')
	open(22,file='./data/phi_2d12.txt')
	open(23,file='./data/phi_2d13.txt')
	open(24,file='./data/phi_2d21.txt')
	open(25,file='./data/phi_2d22.txt')
	open(26,file='./data/phi_2d23.txt')
	open(27,file='./data/phi_2d31.txt')
	open(28,file='./data/phi_2d32.txt')
	open(29,file='./data/phi_2d33.txt')
	open(30,file='./data/phi_2d41.txt')
	open(31,file='./data/phi_2d42.txt')
	open(32,file='./data/phi_2d43.txt')
	open(33,file='./data/phi_2d51.txt')
	open(34,file='./data/phi_2d52.txt')
	open(35,file='./data/phi_2d53.txt')
	open(36,file='./data/phi_2d61.txt')
	open(37,file='./data/phi_2d62.txt')
	open(38,file='./data/phi_2d63.txt')
	open(39,file='./data/phi_2d71.txt')
	open(40,file='./data/phi_2d72.txt')
	open(41,file='./data/phi_2d73.txt')
	open(42,file='./data/phi_2d81.txt')
	open(43,file='./data/phi_2d82.txt')
	open(44,file='./data/phi_2d83.txt')
	open(45,file='./data/phi_2d91.txt')
	open(46,file='./data/phi_2d92.txt')
	open(47,file='./data/phi_2d93.txt')
		read(21,*) ((phi_zx(i,j),j=1,SizeHist),i=1,SizeHist)
		read(22,*) ((phi_xy(i,j),j=1,SizeHist),i=1,SizeHist)
		read(23,*) ((phi_yz(i,j),j=1,SizeHist),i=1,SizeHist)
		read(24,*) ((phi_lzx(i,j),j=1,SizeHist),i=1,SizeHist)
		read(25,*) ((phi_lxy(i,j),j=1,SizeHist),i=1,SizeHist)
		read(26,*) ((phi_lyz(i,j),j=1,SizeHist),i=1,SizeHist)
		read(27,*) ((phi_lezx(i,j),j=1,SizeHist),i=1,SizeHist)
		read(28,*) ((phi_lexy(i,j),j=1,SizeHist),i=1,SizeHist)
		read(29,*) ((phi_leyz(i,j),j=1,SizeHist),i=1,SizeHist)
		read(30,*) ((phi_szx(i,j),j=1,SizeHist),i=1,SizeHist)
		read(31,*) ((phi_sxy(i,j),j=1,SizeHist),i=1,SizeHist)
		read(32,*) ((phi_syz(i,j),j=1,SizeHist),i=1,SizeHist)
		read(33,*) ((phi_sbzx(i,j),j=1,SizeHist),i=1,SizeHist)
		read(34,*) ((phi_sbxy(i,j),j=1,SizeHist),i=1,SizeHist)
		read(35,*) ((phi_sbyz(i,j),j=1,SizeHist),i=1,SizeHist)
		read(36,*) ((phi_sezx(i,j),j=1,SizeHist),i=1,SizeHist)
		read(37,*) ((phi_sexy(i,j),j=1,SizeHist),i=1,SizeHist)
		read(38,*) ((phi_seyz(i,j),j=1,SizeHist),i=1,SizeHist)
		read(39,*) ((phi_azx(i,j),j=1,SizeHist),i=1,SizeHist)
		read(40,*) ((phi_axy(i,j),j=1,SizeHist),i=1,SizeHist)
		read(41,*) ((phi_ayz(i,j),j=1,SizeHist),i=1,SizeHist)
		read(42,*) ((phi_izx(i,j),j=1,SizeHist),i=1,SizeHist)
		read(43,*) ((phi_ixy(i,j),j=1,SizeHist),i=1,SizeHist)
		read(44,*) ((phi_iyz(i,j),j=1,SizeHist),i=1,SizeHist)
		read(45,*) ((phi_qzx(i,j),j=1,SizeHist),i=1,SizeHist)
		read(46,*) ((phi_qxy(i,j),j=1,SizeHist),i=1,SizeHist)
		read(47,*) ((phi_qyz(i,j),j=1,SizeHist),i=1,SizeHist)
	close(47)
	close(46)
	close(45)
	close(44)
	close(43)
	close(42)
	close(41)
	close(40)
	close(39)
	close(38)
	close(37)
	close(36)
	close(35)
	close(34)
	close(33)
	close(32)
	close(31)
	close(30)
	close(29)
	close(28)
	close(27)
	close(26)
	close(25)
	close(24)
	close(23)
	close(22)
	close(21)
end subroutine continue_read_data
!##########################################!


!##############lj_verlet_list##############!
subroutine lj_verlet_list
	!----------------------------------------!
	!
	!----------------------------------------!
	implicit none
	integer i,j,k,l,m,n,p,q,r
	integer icel,jcel,kcel,ncel1,ncel2,ncel3
	real*8, dimension(3) :: rij
	real*8 :: rsqr,rcel1,rcel2,rcel3
	integer, dimension(NN) :: cell_list
	integer,allocatable,dimension(:,:,:)::hoc
	ncel1=int(Lx/rvl)
	ncel2=int(Ly/rvl)
	ncel3=int(Lz/rvl)
	allocate(hoc(0:ncel1-1,0:ncel2-1,0:ncel3-1))

	hoc=0
	rcel1=Lx/ncel1
	rcel2=Ly/ncel2
	rcel3=Lz/ncel3
	do i=1,NN
		icel=int((pos(i,1)+Lx/2)/rcel1)
		jcel=int((pos(i,2)+Ly/2)/rcel2)
		kcel=int(pos(i,3)/rcel3)
		cell_list(i)=hoc(icel,jcel,kcel)
		hoc(icel,jcel,kcel)=i
	end do

	k=0
	do i=1,NN
		icel=int((pos(i,1)+Lx/2)/rcel1)
		jcel=int((pos(i,2)+Ly/2)/rcel2)
		kcel=int(pos(i,3)/rcel3)
		do l=-1,1
			if (icel+l .ge. ncel1) then
				p=icel+l-ncel1
			elseif(icel+l<0) then
				p=icel+l+ncel1
			else
				p=icel+l
			end if
			do m=-1,1
				if (jcel+m .ge. ncel2) then
					q=jcel+m-ncel2
				elseif(jcel+m<0) then
					q=jcel+m+ncel2
				else
					q=jcel+m
				end if
				do n=-1,1
					if (kcel+n .ge. ncel3) then
						cycle
					elseif(kcel+n<0) then
						cycle
					else
						r=kcel+n
					end if
					j=hoc(p,q,r)
					do while (j /= 0)
						call rij_and_rr(rij,rsqr,i,j)
						if ( i/=j .and. rsqr<(rvl*rvl) ) then
							k=k+1
							lj_pair_list(k,1)=i
							lj_pair_list(k,2)=j
						end if
						j=cell_list(j)
					end do
				end do
			end do
		end do
	end do
	npair1=k
end subroutine lj_verlet_list
!##########################################!


!###############write_lj_list##############!	
subroutine write_lj_list
	!----------------------------------------!
	!write position to pos.txt
	!input: pos
	!External Variants: NN
	!----------------------------------------!
	implicit none
	integer :: i,n
	
	n=size(lj_pair_list,1)
	open(38,file='./data/lj_list.txt')
		do i=1, n
			write(38,380) 1.*lj_pair_list(i,1),1.*lj_pair_list(i,2)
			380 format(2F5.0)
		end do
	close(38)
end subroutine write_lj_list
!##########################################!


!#############real_verlet_list#############!
subroutine real_verlet_list
	!----------------------------------------!
	!
	!----------------------------------------!
	implicit none
	integer i,j,k,m,n,p,q,r,u,v,w
	integer icel,jcel,kcel,ncel1,ncel2,ncel3
	real*8, dimension(3) :: rij
	real*8 :: rsqr,rcel1,rcel2,rcel3
	integer, dimension(Nq) :: cell_list
	integer,allocatable,dimension(:,:,:)::hoc
	ncel1=int(Lx/rvc)
	ncel2=int(Ly/rvc)
	ncel3=int(Lz/rvc)
	allocate(hoc(0:ncel1-1,0:ncel2-1,0:ncel3-1))

	hoc=0
	rcel1=Lx/ncel1
	rcel2=Ly/ncel2
	rcel3=Lz/ncel3
	do m=1,Nq
		i=charge(m)
		icel=int((pos(i,1)+Lx/2)/rcel1)
		jcel=int((pos(i,2)+Ly/2)/rcel2)
		kcel=int(pos(i,3)/rcel3)
		cell_list(m)=hoc(icel,jcel,kcel)
		hoc(icel,jcel,kcel)=m
	end do
	k=0
	do m=1,Nq
		i=charge(m)
		icel=int((pos(i,1)+Lx/2)/rcel1)
		jcel=int((pos(i,2)+Ly/2)/rcel2)
		kcel=int(pos(i,3)/rcel3)
		do u=-1,1
			if (icel+u>=ncel1) then
				p=icel+u-ncel1
			elseif(icel+u<0) then
				p=icel+u+ncel1
			else
				p=icel+u
			end if
			do v=-1,1
				if (jcel+v>=ncel2) then
					q=jcel+v-ncel2
				elseif(jcel+v<0) then
					q=jcel+v+ncel2
				else
					q=jcel+v
				end if
				do w=-1,1
					if (kcel+w>=ncel3) then
						cycle
					elseif(kcel+w<0) then
						cycle
					else
						r=kcel+w
					end if
					n=hoc(p,q,r)
					do while (n /= 0)
						j=charge(n)
						call rij_and_rr(rij,rsqr,i,j)
						if ( i/=j .and. rsqr<(rvc*rvc) ) then
							k=k+1
							real_pair_list(k,1)=i
							real_pair_list(k,2)=j
						end if
						n=cell_list(n)
					end do
				end do
			end do
		end do
	end do
	npair2=k
end subroutine real_verlet_list
!##########################################!


!###############write_real_list##############!	
subroutine write_real_list
	!----------------------------------------!
	!write position to pos.txt
	!input: pos
	!External Variants: NN
	!----------------------------------------!
	implicit none
	integer :: i, n
	
	n=size(real_pair_list,1)
	open(41,file='./data/real_list.txt')
		do i=1, n
			write(41,410) 1.*real_pair_list(i,1),1.*real_pair_list(i,2)
			410 format(2F10.0)
		end do
	close(41)
end subroutine write_real_list
!##########################################!


!##################height##################!
subroutine height
	!----------------------------------------!
	!
	!----------------------------------------!
	implicit none
	integer i,j,k,l,m,n,p,q,r,s,num_stretch,num_collapse
	real*8 :: rr,rsqr,rr1,rr2,rr3,maxh,Rg1,Rg1z,Rg2,Rg2z,max_hs_end,min_hs_end,hs_avg_arm
	real*8, dimension(3) :: rij
	real*8, dimension(3) :: rij1,rij2,rij3,f1

	h_avg=0
	hl_avg=0
	hl_max=0
	hl_end=0
	hs_avg=0
	hs_max=0
	hs_end=0
	hs_branch=0

	Re_l=0
	Re_lz=0
	Re_s=0
	Re_sz=0
	Re_ss=0
	Re_ssz=0
	Re_sb=0
	Re_sbz=0

	Rg_l=0
	Rg_lz=0
	Rg_s=0
	Rg_sz=0
	Rg_ss=0
	Rg_ssz=0
	Rg_sb=0
	Rg_sbz=0
	
	kenetic_energy=0
	ratio_stretch=0
	ratio_collapse=0
	ratio_other=0

!!----------------------h_avg-------------------------!
	do i=1,Npe
		h_avg=h_avg+pos(i,3)
	end do
	h_avg=h_avg/Npe																		
!!---------------hl_max,hl_end,hl_avg-----------------!
	do i=1,Ngl																				
		maxh=0
		do j=1,Nml
			hl_avg=hl_avg+pos(Nta+(i-1)*Nml+j,3)
			if (maxh<pos(Nta+(i-1)*Nml+j,3)) then
				maxh=pos(Nta+(i-1)*Nml+j,3)
			end if
		end do
		hl_max=hl_max+maxh
		hl_end=hl_end+pos(Nta+i*Nml,3)
	end do
	hl_avg=hl_avg/Ngl/Nml
	hl_max=hl_max/Ngl
	hl_end=hl_end/Ngl
!!------------hs_max,hs_end,hs_branch,hs_avg-----------!
!!-------------force_sy,force_sn,force_sn--------------!
!!------------force_sy1,force_sn1,force_sn1------------!
!!--------delta_angle1,delta_angle2,delta_angle3-------!
!!-------ratio_stretch,ratio_collapse,ratio_other------!
	do i=1,Nga
		maxh=0
		max_hs_end=0
		min_hs_end=Lz
		hs_avg_arm=0
		do k=1,Nma+1
			hs_avg_arm=hs_avg_arm+pos((i-1)*(arm*Nma+1)+k,3)
			if (maxh<pos((i-1)*(arm*Nma+1)+k,3)) then
				maxh=pos((i-1)*(arm*Nma+1)+k,3)									        !max height
			end if
		end do
		hs_branch=hs_branch+pos((i-1)*(arm*Nma+1)+Nma+1,3)          !branch point
		do j=2,arm
			do k=1,Nma
				hs_avg_arm=hs_avg_arm+pos((i-1)*(arm*Nma+1)+((j-1)*Nma+1)+k,3)  !average height
				if (maxh<pos((i-1)*(arm*Nma+1)+((j-1)*Nma+1)+k,3)) then
					maxh=pos((i-1)*(arm*Nma+1)+((j-1)*Nma+1)+k,3)         !max height
				end if
			end do
			hs_end=hs_end+pos((i-1)*(arm*Nma+1)+1+j*Nma,3)            !end of arms
			if (max_hs_end<pos((i-1)*(arm*Nma+1)+1+j*Nma,3)) then
				max_hs_end=pos((i-1)*(arm*Nma+1)+1+j*Nma,3)
			end if
			if (min_hs_end>pos((i-1)*(arm*Nma+1)+1+j*Nma,3)) then
				min_hs_end=pos((i-1)*(arm*Nma+1)+1+j*Nma,3) 
			end if
		end do
		hs_avg=hs_avg+hs_avg_arm
		hs_max=hs_max+maxh
		hs_avg_arm=hs_avg_arm/(arm*Nma+1)
		if (max_hs_end<hs_avg_arm) then
			ratio_collapse=ratio_collapse+1
			do k=2,Nma+1
				m=(i-1)*(arm*Nma+1)+k
				n=(i-1)*(arm*Nma+1)+k-1
				call rij_and_rr(rij1,rr1,m,n)
				f1=48*rr1**(-4)*(rr1**(-3)-0.5)*rij1
				f1=f1-kfene*R0_2/(R0_2-rr1)*rij1
				f1=f1-lb*Beta*(1/rr1**1.5)*rij1*pos(m,4)*pos(n,4)
				force_sn(k-1,2)=force_sn(k-1,2)+f1(3)/Nga
				force_sn1(ceiling((pos(m,3)+pos(n,3))/2/(Lz/SizeHist)),2)=  &
				      force_sn1(ceiling((pos(m,3)+pos(n,3))/2/(Lz/SizeHist)),2)+f1(3)/Nga
			end do
			do j=2, arm
				do k=1, Nma
					m=(i-1)*(arm*Nma+1)+(j-1)*Nma+1+k
					if (k==1) then
						n=(i-1)*(arm*Nma+1)+Nma+1
					else
						n=(i-1)*(arm*Nma+1)+(j-1)*Nma+1+k-1
					end if
					call rij_and_rr(rij1,rr1,m,n)
					f1=48*rr1**(-4)*(rr1**(-3)-0.5)*rij1
					f1=f1-kfene*R0_2/(R0_2-rr1)*rij1
					f1=f1-lb/Beta*(1/rr1**1.5)*rij1*pos(m,4)*pos(n,4)
					force_sn(k+Nma,2)=force_sn(k+Nma,2)+f1(3)/Nga/(arm-1)
					force_sn1(ceiling((pos(m,3)+pos(n,3))/2/(Lz/SizeHist)),2)=  &
					      force_sn1(ceiling((pos(m,3)+pos(n,3))/2/(Lz/SizeHist)),2)+f1(3)/Nga/(arm-1)
				end do
				m=(i-1)*(arm*Nma+1)+Nma+1
				n=(i-1)*(arm*Nma+1)+j*Nma+1
				call rij_and_rr(rij,rr,m,n)
				p=ceiling(acos(rij(3)/sqrt(rr))/(pi/SizeHist))
				if (p<=0 .or. p>SizeHist) then
					write(*,*)'error in delta_angle, exceeding (0,SizeHist)'
					cycle
				end if
				delta_angle2(p,2)=delta_angle2(p,2)+1
			end do
		elseif (min_hs_end>hs_avg_arm) then
			ratio_stretch=ratio_stretch+1
			do k=2,Nma+1
				m=(i-1)*(arm*Nma+1)+k
				n=(i-1)*(arm*Nma+1)+k-1
				call rij_and_rr(rij1,rr1,m,n)
				f1=48*rr1**(-4)*(rr1**(-3)-0.5)*rij1
				f1=f1-kfene*R0_2/(R0_2-rr1)*rij1
				f1=f1-lb/Beta*(1/rr1**1.5)*rij1*pos(m,4)*pos(n,4)
				force_sy(k-1,2)=force_sy(k-1,2)+f1(3)/Nga
				force_sy1(ceiling((pos(m,3)+pos(n,3))/2/(Lz/SizeHist)),2)=&
							force_sy1(ceiling((pos(m,3)+pos(n,3))/2/(Lz/SizeHist)),2)+f1(3)/Nga
			end do
			do j=2, arm
				do k=1, Nma
					m=(i-1)*(arm*Nma+1)+(j-1)*Nma+1+k
					if (k==1) then
						n=(i-1)*(arm*Nma+1)+Nma+1
					else
						n=(i-1)*(arm*Nma+1)+(j-1)*Nma+1+k-1
					end if
					call rij_and_rr(rij1,rr1,m,n)
					f1=48*rr1**(-4)*(rr1**(-3)-0.5)*rij1
					f1=f1-kfene*R0_2/(R0_2-rr1)*rij1
					f1=f1-lb/Beta*(1/rr1**1.5)*rij1*pos(m,4)*pos(n,4)
					force_sy(k+Nma,2)=force_sy(k+Nma,2)+f1(3)/Nga/(arm-1)
					force_sy1(ceiling((pos(m,3)+pos(n,3))/2/(Lz/SizeHist)),2)=  &
								force_sy1(ceiling((pos(m,3)+pos(n,3))/2/(Lz/SizeHist)),2)+f1(3)/Nga/(arm-1)
				end do
				m=(i-1)*(arm*Nma+1)+Nma+1
				n=(i-1)*(arm*Nma+1)+j*Nma+1
				call rij_and_rr(rij,rr,m,n)
				p=ceiling(acos(rij(3)/sqrt(rr))/(pi/SizeHist))
				if (p<=0 .or. p>SizeHist) then
					write(*,*)'error in delta_angle, exceeding (0,SizeHist)'
					cycle
				end if
				delta_angle1(p,2)=delta_angle1(p,2)+1
			end do
		else
			ratio_other=ratio_other+1
			do k=2,Nma+1
				m=(i-1)*(arm*Nma+1)+k
				n=(i-1)*(arm*Nma+1)+k-1
				call rij_and_rr(rij1,rr1,m,n)
				f1=48*rr1**(-4)*(rr1**(-3)-0.5)*rij1
				f1=f1-kfene*R0_2/(R0_2-rr1)*rij1
				f1=f1-lb/Beta*(1/rr1**1.5)*rij1*pos(m,4)*pos(n,4)
				force_so(k-1,2)=force_so(k-1,2)+f1(3)/Nga
				force_so1(ceiling((pos(m,3)+pos(n,3))/2/(Lz/SizeHist)),2)=  &
							force_so1(ceiling((pos(m,3)+pos(n,3))/2/(Lz/SizeHist)),2)+f1(3)/Nga
			end do
			do j=2, arm
				do k=1, Nma
					m=(i-1)*(arm*Nma+1)+(j-1)*Nma+1+k
					if (k==1) then
						n=(i-1)*(arm*Nma+1)+Nma+1
					else
						n=(i-1)*(arm*Nma+1)+(j-1)*Nma+1+k-1
					end if
					call rij_and_rr(rij1,rr1,m,n)
					f1=48*rr1**(-4)*(rr1**(-3)-0.5)*rij1
					f1=f1-kfene*R0_2/(R0_2-rr1)*rij1
					f1=f1-lb/Beta*(1/rr1**1.5)*rij1*pos(m,4)*pos(n,4)
					force_so(k+Nma,2)=force_so(k+Nma,2)+f1(3)/Nga/(arm-1)
					force_so1(ceiling((pos(m,3)+pos(n,3))/2/(Lz/SizeHist)),2)=&
								force_so1(ceiling((pos(m,3)+pos(n,3))/2/(Lz/SizeHist)),2)+f1(3)/Nga/(arm-1)
				end do
				m=(i-1)*(arm*Nma+1)+Nma+1
				n=(i-1)*(arm*Nma+1)+1+j*Nma
				call rij_and_rr(rij,rr,m,n)
				p=ceiling(acos(rij(3)/sqrt(rr))/(pi/SizeHist))
				if (p<=0 .or. p>SizeHist) then
					write(*,*)'error in delta_angle, exceeding (0,SizeHist)'
					cycle
				end if
				delta_angle3(p,2)=delta_angle3(p,2)+1
			end do
		end if		
	end do
	hs_avg=hs_avg/(Nga*(arm*Nma+1))
	hs_max=hs_max/Nga
	hs_end=hs_end/(Nga*(arm-1))
	hs_branch=hs_branch/Nga
	ratio_stretch=ratio_stretch/Nga
	ratio_collapse=ratio_collapse/Nga
	ratio_other=ratio_other/Nga
!!---------------Re_l,Re_lz,Rg_l,Rg_lz------------------!	
	do i=1,Ngl
		m=Nta+(i-1)*Nml+1
		n=Nta+i*Nml
		call rij_and_rr(rij,rr,m,n)
		Re_l=Re_l+rr
		Re_lz=Re_lz+rij(3)*rij(3)
		Rg1=0
		Rg1z=0
		do j=1,Nml-1
			do k=j+1,Nml
				m=Nta+(i-1)*Nml+j
				n=Nta+(i-1)*Nml+k
				call rij_and_rr(rij,rr,m,n)
				Rg1=Rg1+rr
				Rg1z=Rg1z+rij(3)*rij(3)
			end do
			m=Nta+(i-1)*Nml+j+1
			n=Nta+(i-1)*Nml+j
			call rij_and_rr(rij1,rr1,m,n)
			f1=48*rr1**(-4)*(rr1**(-3)-0.5)*rij1
			f1=f1-kfene*R0_2/(R0_2-rr1)*rij1
			f1=f1-lb*Beta*(1/rr1)*rij1*pos(m,4)*pos(n,4)
			force_l(j,2)=force_l(j,2)+f1(3)/Ngl
			force_l1(ceiling((pos(m,3)+pos(n,3))/2/(Lz/SizeHist)),2)=&
						force_l1(ceiling((pos(m,3)+pos(n,3))/2/(Lz/SizeHist)),2)+f1(3)/Ngl
		end do
		Rg_l=Rg_l+Rg1/(Nml+1)/(Nml+1)
		Rg_lz=Rg_lz+Rg1z/(Nml+1)/(Nml+1)
	end do
	Re_l=Re_l/Ngl
	Re_lz=Re_lz/Ngl
	Rg_l=Rg_l/Ngl
	Rg_lz=Rg_lz/Ngl
	!!----Re_ss,Re_ssz,Rg_ss,Rg_ssz,Re_sb,Resbz,Rg_sb,Rg_sbz,Re_s,Re_sz----!
	do i=1,Nga
		m=(i-1)*(arm*Nma+1)+1
		n=(i-1)*(arm*Nma+1)+Nma+1
		call rij_and_rr(rij,rr,m,n)
		Re_ss=Re_ss+rr
		Re_ssz=Re_ssz+rij(3)*rij(3)
		Rg1=0
		Rg1z=0
		do p=1,Nma
			do q=p+1,Nma+1
				m=(i-1)*(arm*Nma+1)+p
				n=(i-1)*(arm*Nma+1)+q
				call rij_and_rr(rij,rr,m,n)
				Rg1=Rg1+rr
				Rg1z=Rg1z+rij(3)*rij(3)
			end do
		end do
		Rg_ss=Rg_ss+Rg1/(Nma+2)/(Nma+2)
		Rg_ssz=Rg_ssz+Rg1z/(Nma+2)/(Nma+2)

		do j=2,arm
			m=(i-1)*(arm*Nma+1)+1
			n=(i-1)*(arm*Nma+1)+1+j*Nma
			call rij_and_rr(rij,rr,m,n)
			Re_s=Re_s+rr
			Re_sz=Re_sz+rij(3)*rij(3)
			m=(i-1)*(arm*Nma+1)+Nma+1
			n=(i-1)*(arm*Nma+1)+1+j*Nma
			call rij_and_rr(rij,rr,m,n)
			Re_sb=Re_sb+rr
			Re_sbz=Re_sbz+rij(3)*rij(3)
			Rg2=0
			Rg2z=0
			do p=1,Nma-1
				do q=p+1,Nma
					m=(i-1)*(arm*Nma+1)+1+((j-1)*Nma+p)
					n=(i-1)*(arm*Nma+1)+1+((j-1)*Nma+q)
					call rij_and_rr(rij,rr,m,n)
					Rg2=Rg2+rr
					Rg2z=Rg2z+rij(3)*rij(3)
				end do
			end do
			Rg_sb=Rg_sb+Rg2/(Nma+1)/(Nma+1)
			Rg_sbz=Rg_sbz+Rg2z/(Nma+1)/(Nma+1)
		end do
	end do
	Re_ss=Re_ss/Nga
	Re_ssz=Re_ssz/Nga
	Rg_ss=Rg_ss/Nga
	Rg_ssz=Rg_ssz/Nga
	Re_sb=Re_sb/Nga/(arm-1)
	Re_sbz=Re_sbz/Nga/(arm-1)
	Rg_sb=Rg_sb/Nga/(arm-1)
	Rg_sbz=Rg_sbz/Nga/(arm-1)
	Re_s=Re_s/Nga/(arm-1)
	Re_sz=Re_sz/Nga/(arm-1)
!!-------------Rg_s,Rg_sz-------------!
	do i=1,Nga
		Rg2=0
		Rg2z=0
		do j=1,arm*Nma
			do k=j+1,arm*Nma+1
				m=(i-1)*(arm*Nma+1)+j
				n=(i-1)*(arm*Nma+1)+k
				call rij_and_rr(rij,rr,m,n)
				Rg2=Rg2+rr
				Rg2z=Rg2z+rij(3)*rij(3)
			end do
		end do
		Rg_s=Rg_s+Rg2/(arm*Nma+1+1)/(arm*Nma+1+1)
		Rg_sz=Rg_sz+Rg2z/(arm*Nma+1+1)/(arm*Nma+1+1)
	end do
	Rg_s=Rg_s/Nga
	Rg_sz=Rg_sz/Nga
!!----------------kenentic_energy--------------!
	kenetic_energy=0.
	do i=1,NN
		kenetic_energy=kenetic_energy+dot_product(vel(i,:),vel(i,:))/2.
	end do
	kenetic_energy=kenetic_energy/(NN-N_anchor)
end subroutine height
!##########################################!


!###############write_height###############!
subroutine write_height(j)
	!----------------------------------------!
	!
	!----------------------------------------!
	implicit none
	integer, intent(in) :: j
	
! 		open(36,position='append', file='./data/height.txt')
! 			write(36,361) 1.*j, h_avg
! 		close(36)
! 		361 format(2F17.6)
	open(36,position='append', file='./data/height.txt')
		write(36,360) 1.*j, h_avg, hl_max, hl_end, hl_avg, hs_max, hs_end, hs_branch, hs_avg
	close(36)
	open(36,position='append', file='./data/Re.txt')
		write(36,360) 1.*j, Re_l, Re_lz, Re_ss, Re_ssz, Re_sb, Re_sbz, Re_s, Re_sz
	close(36)
	open(36,position='append', file='./data/Rg.txt')
		write(36,360) 1.*j, Rg_l, Rg_lz, Rg_ss, Rg_ssz, Rg_sb, Rg_sbz, Rg_s, Rg_sz
	close(36)
	open(36,position='append', file='./data/KE.txt')
		write(36,370) 1.*j, kenetic_energy, ratio_stretch, ratio_collapse, ratio_other
	close(36)
	360 format(9F17.6)
	370 format(4F17.6)
end subroutine write_height
!##########################################!


!###############histogram1#################!
subroutine histogram
	!----------------------------------------!
	!input: pos
	!output: hist1(distribution hisotgram from PE to rod)
	!External Variants: Npe
	!----------------------------------------!
	implicit none
	integer :: i, j, k, l, m, n, p, q, r, x, y, z
	real*8, dimension(3) :: rij1,rij2,rij3,f1
	real*8 rsqr,theta,rr1,rr2,rr3,he_min,he_max,hb
	
	
	!!!!!!!!!!!!!!!!!!!!!!!!1d_height_distribution!!!!!!!!!!!!!!!!!!!!!
	!!-------------------phi_tot-----------------!
	do i=1,Npe
		k=ceiling(pos(i,3)/(Lz/SizeHist))
		if (k==0) cycle
		if (k<0 .or. k>SizeHist) then
			write(*,*) 'Wrong in phi_tot: k<0 or k>SizeHist!'
			cycle
		end if
		phi_tot(k,2)=phi_tot(k,2)+1
	end do
	!!-----------------phi_l,phi_le---------------!
	do i=Nta+1,Npe
		!total monomers
		k=ceiling(pos(i,3)/(Lz/SizeHist))
		if (k==0) cycle
		if (k<0 .or. k>SizeHist) then
			write(*,*) 'Wrong in phi_l: k<0 or k>SizeHist!'
			cycle
		end if
		phi_l(k,2)=phi_l(k,2)+1
		!end  monomers
		if (mod(i-Nta,Nml)==0) then
			phi_le(k,2)=phi_le(k,2)+1
		end if
	end do
	!!-----------------phi_s,phi_se---------------!
	do i=1, Nta
		!total monomers
		k=ceiling(pos(i,3)/(Lz/SizeHist))
		if(k==0) cycle
		if (k<0 .or. k>SizeHist) then
			write(*,*) 'Wrong in phi_s: k<0 or k>SizeHist!'
			cycle
		end if
		phi_s(k,2)=phi_s(k,2)+1
		!branching monomers
		if (mod(i,arm*Nma+1)==Nma+1) then
			phi_sb(k,2)=phi_sb(k,2)+1
		!end monomers
		elseif (mod(mod(i,arm*Nma+1)-Nma-1,Nma)==0) then
			phi_se(k,2)=phi_se(k,2)+1
		end if
	end do
	!!--------------phi_i,phi_q,phi_q--------------!
	do i=1,Nq
		!total charged monomers
		k=ceiling(pos(charge(i),3)/(Lz/SizeHist))
		if (k<=0 .or. k>SizeHist) then
			write(*,*) 'Wrong in phi_q: k<0 or k>SizeHist!'
			cycle
		end if
		phi_q(k,2)=phi_q(k,2)+pos(charge(i),4)
		if ( i<= Nq/(nint(abs(qq))+1) ) then		!ions
			phi_i(k,2)=phi_i(k,2)+1.
		else																		!aions
			phi_a(k,2)=phi_a(k,2)+1.
		end if
	end do
	!!!!!!!!!!!!!!!!!!!!!!!!1d_theta_distribution!!!!!!!!!!!!!!!!!!!!!
	!!------------------theta_l,theta_lz------------------!
	do i=1,Ngl
		do j=2,Nml-1
			l=Nta+(i-1)*Nml+j
			m=Nta+(i-1)*Nml+j-1
			n=Nta+(i-1)*Nml+j+1
			call rij_and_rr(rij1,rr1,l,m)
			call rij_and_rr(rij2,rr2,l,n)
			call rij_and_rr(rij3,rr3,m,n)
			theta=acos((rr1+rr2-rr3)/2/sqrt(rr1)/sqrt(rr2))
			k=ceiling(theta/(pi/SizeHist))
			if (k<=0 .or. k>SizeHist) then
				write(*,*) 'Wrong in phi_se: k<0 or k>SizeHist!'
				cycle
			end if
			theta_l(k,2)=theta_l(k,2)+1
			theta=acos(rij1(3)/sqrt(rr1))
			k=ceiling(theta/(pi/SizeHist))
			if (k<=0 .or. k>SizeHist) then
				write(*,*) 'Wrong in phi_se: k<0 or k>SizeHist!'
				cycle
			end if
			theta_lz(k,2)=theta_lz(k,2)+1
		end do
	end do
	!!----theta_ssl,theta_sslz,theta_sbl,theta_sblz,theta_bez----!
	do i=1,Nga
		do j=2,Nma
			l=(i-1)*(arm*Nma+1)+j
			m=(i-1)*(arm*Nma+1)+j-1
			n=(i-1)*(arm*Nma+1)+j+1
			call rij_and_rr(rij1,rr1,l,m)
			call rij_and_rr(rij2,rr2,l,n)
			call rij_and_rr(rij3,rr3,m,n)
			theta=acos((rr1+rr2-rr3)/2/sqrt(rr1)/sqrt(rr2))
			k=ceiling(theta/(pi/SizeHist))
			if (k<=0 .or. k>SizeHist) then
				write(*,*) 'Wrong in phi_se: k<0 or k>SizeHist!'
				cycle
			end if
			theta_ssl(k,2)=theta_ssl(k,2)+1
			theta=acos(rij1(3)/sqrt(rr1))
			k=ceiling(theta/(pi/SizeHist))
			if (k<=0 .or. k>SizeHist) then
				write(*,*) 'Wrong in phi_se: k<0 or k>SizeHist!'
				cycle
			end if
			theta_sslz(k,2)=theta_sslz(k,2)+1
		end do
		
		do j=2,arm
			l=(i-1)*(arm*Nma+1)+j*Nma+1
			m=(i-1)*(arm*Nma+1)+Nma+1
			call rij_and_rr(rij1,rr1,l,m)
			theta=acos(rij1(3)/sqrt(rr1))
			p=ceiling(theta/(pi/SizeHist))
			theta_bez(p,2)=theta_bez(p,2)+1
			do k=2,Nma-1
				l=(i-1)*(arm*Nma+1)+(j-1)*Nma+1+k
				m=(i-1)*(arm*Nma+1)+(j-1)*Nma+1+k-1
				n=(i-1)*(arm*Nma+1)+(j-1)*Nma+1+k+1
				call rij_and_rr(rij1,rr1,l,m)
				call rij_and_rr(rij2,rr2,l,n)
				call rij_and_rr(rij3,rr3,m,n)
				theta=acos((rr1+rr2-rr3)/2/sqrt(rr1)/sqrt(rr2))
				p=ceiling(theta/(pi/SizeHist))
				if (p<=0 .or. p>SizeHist) then
					write(*,*) 'Wrong in phi_se: k<0 or k>SizeHist!'
					cycle
				end if
				theta=acos(rij1(3)/sqrt(rr1))
				theta_sbl(p,2)=theta_sbl(p,2)+1
				p=ceiling(theta/(pi/SizeHist))
				if (p<=0 .or. p>SizeHist) then
					write(*,*) 'Wrong in phi_se: k<0 or k>SizeHist!'
					cycle
				end if
				theta_sblz(p,2)=theta_sblz(p,2)+1
			end do
		end do
	end do
	
	!!!!!!!!!!!!!!!!!!!!!!!!2d_distribution!!!!!!!!!!!!!!!!!!!!!
	!!------------------phi_zx,phi_xy,phi_szx,phi_sxy------------------!
	do i=1,Nta
		x=ceiling((pos(i,1)+Lx/2)/(Lx/SizeHist))
		y=ceiling((pos(i,2)+Ly/2)/(Ly/SizeHist))
		z=ceiling(pos(i,3)/(Lz/SizeHist))
		if (x==0 .or. y==0 .or. z==0) cycle
		phi_szx(x,z)=phi_szx(x,z)+1						!total distribution of star brushes
		phi_sxy(x,y)=phi_sxy(x,y)+1						!total distribution of star brushes
		phi_syz(y,z)=phi_syz(y,z)+1						!total distribution of star brushes
		phi_zx(x,z)=phi_zx(x,z)+1							!total distribution of all brushes
		phi_xy(x,y)=phi_xy(x,y)+1							!total distribution of all brushes
		phi_yz(y,z)=phi_yz(y,z)+1							!total distribution of all brushes
		if(mod(i,arm*Nma+1)==Nma+1) then
			phi_sbzx(x,z)=phi_sbzx(x,z)+1				!distribution of branching monomers of the star brushes
			phi_sbxy(x,y)=phi_sbxy(x,y)+1				!distribution of barnching monomers of the star brushes
			phi_sbyz(y,z)=phi_sbyz(y,z)+1				!distribution of barnching monomers of the star brushes
		elseif (mod(mod(i,arm*Nma+1)-Nma-1,Nma)==0) then
			phi_sezx(x,z)=phi_sezx(x,z)+1				!distribution of end monomers of the star brushes
			phi_sexy(x,y)=phi_sexy(x,y)+1				!distribution of end monomers of the star brushes
			phi_seyz(y,z)=phi_seyz(y,z)+1				!distribution of end monomers of the star brushes
		end if
	end do
	!!------------------phi_zx,phi_xy,phi_lzx,phi_lxy------------------!
	do i=Nta+1,Npe
		x=ceiling((pos(i,1)+Lx/2)/(Lx/SizeHist))
		y=ceiling((pos(i,2)+Ly/2)/(Ly/SizeHist))
		z=ceiling(pos(i,3)/(Lz/SizeHist))
		if (x==0 .or. y==0 .or. z==0) cycle
		phi_lzx(x,z)=phi_lzx(x,z)+1						!total distribution of linear brushes
		phi_lxy(x,y)=phi_lxy(x,y)+1						!total distribution of linear brushes		
		phi_lyz(y,z)=phi_lyz(y,z)+1						!total distribution of linear brushes		
		phi_zx(x,z)=phi_zx(x,z)+1							!total distribution of all brushes
		phi_xy(x,y)=phi_xy(x,y)+1							!total distribution of all brushes
		phi_yz(y,z)=phi_yz(y,z)+1							!total distribution of all brushes
		if (mod(i-Nta,Nml)==0) then
			phi_lezx(x,z)=phi_lezx(x,z)+1				!distribution of end monomers of the linear brushes
			phi_lexy(x,y)=phi_lexy(x,y)+1				!distribution of end monomers of the linear brushes
			phi_leyz(y,z)=phi_leyz(y,z)+1				!distribution of end monomers of the linear brushes
		end if
	end do
	!!------------------phi_qzx,phi_qxy,phi_izx,phi_ixy,phi_azx,phi_axy------------------!
	do i=1,Nq
		x=ceiling((pos(charge(i),1)+Lx/2)/(Lx/SizeHist))
		y=ceiling((pos(charge(i),2)+Ly/2)/(Ly/SizeHist))
		z=ceiling(pos(charge(i),3)/(Lz/SizeHist))
		if (x==0 .or. y==0 .or. z==0) cycle
		phi_qzx(x,z)=phi_qzx(x,z)+pos(i,4)
		phi_qxy(x,y)=phi_qxy(x,y)+pos(i,4)
		phi_qyz(y,z)=phi_qyz(y,z)+pos(i,4)
		if (i<=Nq/(nint(abs(qq))+1)) then
			phi_izx(x,z)=phi_izx(x,z)+1
			phi_ixy(x,y)=phi_ixy(x,y)+1
			phi_iyz(y,z)=phi_iyz(y,z)+1
		else
			phi_azx(x,z)=phi_azx(x,z)+1
			phi_axy(x,y)=phi_axy(x,y)+1
			phi_ayz(y,z)=phi_ayz(y,z)+1
		end if
	end do
	 
end subroutine histogram
!##########################################!


!################write_hist################!	
subroutine write_hist
	!----------------------------------------!
	!write distribution histogram to the file hist1.txt ... hist4.txt
	!input: hist1, hist2, hist3, hist4
	!External Variants: SizeHist, LengthHist1...LengthHist4
	!----------------------------------------!
	implicit none
	integer i,j
	
	open(31,file='./data/phi.txt')
		do i=1,SizeHist
			phi_tot(i,1)=i*Lz/SizeHist
			write(31,340) phi_tot(i,1),phi_tot(i,2),phi_l(i,2),phi_le(i,2),phi_s(i,2),phi_sb(i,2),&
& 															 phi_se(i,2), phi_a(i,2),phi_i(i,2), phi_q(i,2)			
		end do
		340 format(10F17.6)
	close(31)
	open(32,file='./data/theta.txt')
		do i=1,SizeHist
			theta_l(i,1)=i*pi/SizeHist
			write(32,350) theta_l(i,1),   theta_l(i,2),  theta_lz(i,2),  theta_ssl(i,2),&
&										theta_sslz(i,2),theta_sbl(i,2),theta_sblz(i,2),theta_bez(i,2)
		end do
		350 format(8F17.6)
	close(32)
	
	open(33,file='./data/force_liear.txt')
		do i=1,Nml-1
			write(33,330) i*1., force_l(i,2)
		end do
		330 format(2F17.6)
	close(33)

	open(34,file='./data/force_star.txt')
		do i=1,Nma*2
			write(34,320) i*1., force_sy(i,2), force_sn(i,2), force_so(i,2)
		end do
		320 format(4F17.6)
	close(34)

		open(331,file='./data/force_liear1.txt')
		do i=1,SizeHist
			write(331,3301) i*1., force_l1(i,2)
		end do
		3301 format(2F17.6)
	close(331)

	open(341,file='./data/force_star1.txt')
		do i=1,SizeHist
			write(341,3201) i*1., force_sy1(i,2), force_sn1(i,2), force_so1(i,2)
		end do
		3201 format(4F17.6)
	close(341)
	
	open(35,file='./data/delta_angle.txt')
		do i=1,SizeHist
			write(35,310) i*pi/SizeHist, delta_angle1(i,2), delta_angle2(i,2), delta_angle3(i,2)
		end do
		310 format(4F17.6)
	close(35)
	
	open(51,file='./data/phi_2d11.txt')
	open(52,file='./data/phi_2d12.txt')
	open(53,file='./data/phi_2d13.txt')
	open(54,file='./data/phi_2d21.txt')
	open(55,file='./data/phi_2d22.txt')
	open(56,file='./data/phi_2d23.txt')
	open(57,file='./data/phi_2d31.txt')
	open(58,file='./data/phi_2d32.txt')
	open(59,file='./data/phi_2d33.txt')
	open(60,file='./data/phi_2d41.txt')
	open(61,file='./data/phi_2d42.txt')
	open(62,file='./data/phi_2d43.txt')
	open(63,file='./data/phi_2d51.txt')
	open(64,file='./data/phi_2d52.txt')
	open(65,file='./data/phi_2d53.txt')
	open(66,file='./data/phi_2d61.txt')
	open(67,file='./data/phi_2d62.txt')
	open(68,file='./data/phi_2d63.txt')
	open(69,file='./data/phi_2d71.txt')
	open(70,file='./data/phi_2d72.txt')
	open(71,file='./data/phi_2d73.txt')
	open(72,file='./data/phi_2d81.txt')
	open(73,file='./data/phi_2d82.txt')
	open(74,file='./data/phi_2d83.txt')
	open(75,file='./data/phi_2d91.txt')
	open(76,file='./data/phi_2d92.txt')
	open(77,file='./data/phi_2d93.txt')
		do i=1,SizeHist
			write(51,'(500I10)') (phi_zx(i,j),j=1,SizeHist) 
			write(52,'(500I10)') (phi_xy(i,j),j=1,SizeHist)  
			write(53,'(500I10)') (phi_yz(i,j),j=1,SizeHist)  
			write(54,'(500I10)') (phi_lzx(i,j),j=1,SizeHist)  
			write(55,'(500I10)') (phi_lxy(i,j),j=1,SizeHist) 
			write(56,'(500I10)') (phi_lyz(i,j),j=1,SizeHist) 
			write(57,'(500I10)') (phi_lezx(i,j),j=1,SizeHist)  
			write(58,'(500I10)') (phi_lexy(i,j),j=1,SizeHist)  
			write(59,'(500I10)') (phi_leyz(i,j),j=1,SizeHist)  
			write(60,'(500I10)') (phi_szx(i,j),j=1,SizeHist) 
			write(61,'(500I10)') (phi_sxy(i,j),j=1,SizeHist)  
			write(62,'(500I10)') (phi_syz(i,j),j=1,SizeHist)  
			write(63,'(500I10)') (phi_sbzx(i,j),j=1,SizeHist)  
			write(64,'(500I10)') (phi_sbxy(i,j),j=1,SizeHist) 
			write(65,'(500I10)') (phi_sbyz(i,j),j=1,SizeHist) 
			write(66,'(500I10)') (phi_sezx(i,j),j=1,SizeHist)  
			write(67,'(500I10)') (phi_sexy(i,j),j=1,SizeHist)  
			write(68,'(500I10)') (phi_seyz(i,j),j=1,SizeHist)  
			write(69,'(500I10)') (phi_azx(i,j),j=1,SizeHist) 
			write(70,'(500I10)') (phi_axy(i,j),j=1,SizeHist)  
			write(71,'(500I10)') (phi_ayz(i,j),j=1,SizeHist)  
			write(72,'(500I10)') (phi_izx(i,j),j=1,SizeHist)  
			write(73,'(500I10)') (phi_ixy(i,j),j=1,SizeHist) 
			write(74,'(500I10)') (phi_iyz(i,j),j=1,SizeHist) 
			write(75,'(500I10)') (phi_qzx(i,j),j=1,SizeHist)  
			write(76,'(500I10)') (phi_qxy(i,j),j=1,SizeHist)   
			write(77,'(500I10)') (phi_qyz(i,j),j=1,SizeHist)   
		end do
	close(51)
	close(52)
	close(53)
	close(54)
	close(55)
	close(56)
	close(57)
	close(58)
	close(59)
	close(60)
	close(61)
	close(62)
	close(63)
	close(64)
	close(65)
	close(66)
	close(67)
	close(68)
	close(69)
	close(70)
	close(71)
	close(72)
	close(73)
	close(74)
	close(75)
	close(76)
	close(77)
end subroutine write_hist
!##########################################!	


!#################write_pos################!	
subroutine write_pos
	!----------------------------------------!
	!write position to pos.txt
	!input: pos
	!External Variants: NN
	!----------------------------------------!
	implicit none
	integer :: i

	open(30,file='./data/pos.txt')
		do i=1, NN
			write(30,300) pos(i,1), pos(i,2), pos(i,3), pos(i,4)
			300 format(4F17.6)
		end do
	close(30)
end subroutine write_pos
!##########################################!	


!###############write_pos1#################!	
subroutine write_pos1
	!----------------------------------------!
	!write the step j and pos to the file pos1.txt
	!input: j, pos
	!External Variants: NN
	!----------------------------------------!
	implicit none
	integer :: i

	open(31,file='./data/pos1.txt')
		do i=1, NN
			write(31,310) pos(i,1), pos(i,2), pos(i,3), pos(i,4)
			310 format(4F17.6)
		end do
	close(31)
end subroutine write_pos1	
!##########################################!	


!#################write_vel################!	
subroutine write_vel
	!----------------------------------------!
	!write position to pos.txt
	!input: pos
	!External Variants: NN
	!----------------------------------------!
	implicit none
	integer :: i

	open(32,file='./data/vel.txt')
		do i=1, NN
			write(32,320) vel(i,1), vel(i,2), vel(i,3)
			320 format(3F17.6)
		end do
	close(32)
end subroutine write_vel
!##########################################!


!#################write_vel################!	
subroutine write_vel1(j)
	!----------------------------------------!
	!write position to pos.txt
	!input: pos
	!External Variants: NN
	!----------------------------------------!
	implicit none
	integer :: i
	integer, intent(in) :: j
	
	open(33,file='./data/vel1.txt')
		do i=1, NN
			write(33,330) vel(i,1), vel(i,2), vel(i,3)
			330 format(3F17.6)
		end do
	close(33)
	open(32,file='./start_time.txt')
		write(32,*) 1
		write(32,*) j
		call cpu_time(finished)
		total_time=total_time+finished-started
		call cpu_time(started)
		write(32,*) total_time
		write(32,*) 'time:(minutes)', real(total_time/60)
		write(32,*) 'time:(hours)', real(total_time/3600)
		write(32,*) 'time:(days)', real(total_time/86400)
	close(32)
end subroutine write_vel1
!##########################################!


!#################write_acc################!	
subroutine write_acc
	!----------------------------------------!
	!write position to pos.txt
	!input: pos
	!External Variants: NN
	!----------------------------------------!
	implicit none
	integer :: i
	
	open(37,file='./data/acc.txt')
		do i=1, NN
			write(37,370) acc(i,1), acc(i,2), acc(i,3)
			370 format(3F17.6)
		end do
	close(37)
end subroutine write_acc
!##########################################!


!####################time##################!	
subroutine write_time(time)
	real*8, intent(in) :: time
	open(10,file='./data/time.txt')
	write(10,*) 'time:(seconds)', real(total_time)
	write(10,*) 'time:(minutes)', real(total_time/60)
	write(10,*) 'time:(hours)', real(total_time/3600)
	write(10,*) 'time:(days)', real(total_time/86400)
	write(10,*) 'Lx:', real(Lx)
	write(10,*) 'Ly:', real(Ly)
	write(10,*) 'Lz:', real(Lz)
	write(10,*) 'Nq:', Nq
	write(10,*) 'NN:', NN
	write(10,*) 'sigmag:', real(sigmag)
	write(10,*) 'qq:',nint(qq)
	close(10)
end subroutine write_time
!##########################################!


end module subroutines