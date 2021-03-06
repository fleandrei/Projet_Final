using Printf
using PyPlot
using SpecialFunctions
using LinearAlgebra 
# using PyCall
# @pyimport matplotlib.animation as anim
# using PyPlot
# using Plots
using Makie

include("./polar.jl")
include("./diffraction.jl")


k              = 2*pi
lambda         = 2*pi/k # longueur d'onde
h              = 1/30  #pas de la grille
taille_espace  = 20 # taille total de la grille
taille_matrice = floor(Int64, taille_espace*1/h)

beta = pi #Angle de l'onde incidente
e    = 10^(-12)

T = 10
w = 2* pi /lambda




##########CODE############

# A1 = 1.5
# A2 = 0.75
# A3 = 0.03

# N1 = floor(Int64, k*A1 + cbrt( (1/(2*sqrt(2))) *log(2*sqrt(2)*pi*A1*k*e) )^(2) * cbrt(k*A1) + 1)
# N2 = floor(Int64, k*A2 + cbrt( (1/(2*sqrt(2))) *log(2*sqrt(2)*pi*A2*k*e) )^(2) * cbrt(k*A2) + 1)
# N3 = floor(Int64, k*A3 + cbrt( (1/(2*sqrt(2))) *log(2*sqrt(2)*pi*A3*k*e) )^(2) * cbrt(k*A3) + 1)





# Obstacle=[ [-6,1,A1,N1],[-3,-1,A1,N1],[0,1,A1,N1],[3,-1,A1,N1],[6,1,A1,N1]]
# println(" ----- N size ------\n")
# println(N1,"  ",N2,"  ",N3,"\n")
# println(" ----- ------ ------\n")

# ------- initialisation du problem -------
println("--------------------------------------------------\n")
println("---------- Initialisation du Probleme ------------\n")
println("--------------------------------------------------\n")
boules_min = 3
boules_max = 3
xmin = - taille_espace/2
xmax =   taille_espace/2	
ymin = xmin
ymax = xmax
rmin = 0.1
rmax = 1.5


r = 1
Np = floor(Int64, k*r + cbrt( (1/(2*sqrt(2))) *log(2*sqrt(2)*pi*r*k*e) )^(2) * cbrt(k*r) + 1)
M = 5
Obstacle = [[0,6,r,Np],[0,3,r,Np],[0,0,r,Np],[0,-3,r,Np],[0,-6,r,Np]]
# Obstacle,M = initBoulesAlea(boules_min,boules_max,xmin,xmax,ymin,ymax,rmin,rmax)

println(Obstacle)

# Image = zeros(Float64, taille_matrice, taille_matrice)

# for i = 1:taille_matrice

# 		for j = 1:taille_matrice

# 			x,y      = coordonnees(i, j, h, taille_espace)
# 			r,lambda = conversion_polaire(x, y)

# 			if !Is_inDisk(x,y,Obstacle, M)

# 				Image[i,j] = 1
# 				#println("Image [",i,",",j,"] = ", Image[i,j],"\n")
# 			end
# 		end
# 		println("Image [",i,"]","\n")
# 	end

# #Affichage graphique
	
# imshow(transpose(Image), extent=(xmin, xmax, ymin, ymax))


println("--------------------------------------------------\n")
println("----------- Construction du Probleme -------------\n")
println("--------------------------------------------------\n")

Dm = Extraire_Dm(M, Obstacle, beta, k)
B  = Calcule_B(M ,Obstacle, beta,k,Dm)
println("----- B -----:\n")
show(stdout, "text/plain",B)
println("\n")
println("----- fin B -----:\n")
A  = Calcule_A(M, Obstacle, k)
C  = Calcule_C(A,B)

println("----- C -----:\n")
show(stdout, "text/plain",C)
println("\n")
println("----- fin C -----:\n")

println("----- A -----:\n")
# for i= 1:2*(2*2 +1)
# 	println(A[i])
# end
show(stdout, "text/plain",A)
println("\n")
println("----- fin A -----:\n")

println("----- B -----:\n")
println(B)
println("----- fin B -----:\n")

# B_reconstruct = A*C

# println("----- B_reconstruct -----:\n")
# println(B_reconstruct)
# println("----- fin B_reconstruct -----:\n")



Cm = Extraire_Cm(C,M,Obstacle)
println("----- Cm -----:\n")
show(stdout, "text/plain",Cm)
println("\n")
println(size(Cm))
println("----- fin Cm -----:\n")

println("----- normA -----:\n",opnorm(A,Inf),"\n----- ----- -----:\n")
println("----- normB -----:\n",opnorm(B,Inf),"\n----- ----- -----:\n")
println("----- normC -----:\n",opnorm(C,Inf),"\n----- ----- -----:\n")





println("--------------------------------------------------\n")
println("----------------- Creating Images ----------------\n")
println("--------------------------------------------------\n")

Image_save(Obstacle,Cm,Dm,M,beta)




# ------------ video time -----------=----
# Sequence = Video_Mult(Obstacle,Cm,Dm, M,beta,T)

# scene = Scene()
# scene = heatmap(Sequence[1])

#  record(scene, "test.mp4", 1:T; framerate = 10) do t
#         scene =  heatmap(Sequence[t])# animate scene
#         # `scene.plots` gives the plots of the Scene.
#         # `scene.plots[1]` is always the Axis if it exists,
#         # and `scene.plots[2]` onward are the user-defined plots.
# end
