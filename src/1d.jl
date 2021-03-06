using Printf
using PyPlot
using SpecialFunctions
using LinearAlgebra 
using PyCall
@pyimport matplotlib.animation as anim
# using PyPlot
using Plots

include("./polar.jl")
include("./diffraction.jl")
#using Polar
#import Polar


########### VARIABLE #############

k = 2*pi
lambda = 2*pi/k # longueur d'onde
h = lambda/60  #pas de la grille
a = 1 # rayon de l'obstacle
taille_espace=10 # taille total de la grille
taille_matrice=convert(Int64, taille_espace*1/h)


alpha=pi #Angle de l'onde incidente
alphap=0 #Angle de l'obstacle
bp=0
rp=3
e=10^(-12)


########### FONCTIONS #############

function dim1(h_, a_, alpha_, alphap_, bp_, rp_)
	Np=floor(Int64, k*a_ + cbrt(1/(2*sqrt(2))*log(2*sqrt(2)*pi*k*e))^(2) * (k*a_)^(1/3) +1)

	#Cm,Dm,Hm=CDH(bp_, alphap_, alpha_, Np, k)
	Cm=CoeFourrier_OndeDiffracte(bp_, alphap_, alpha_, Np, k, a)
	Dm=CoeFourrier_OndeInc(bp_, alphap_, alpha_, Np, k)
	
	# declaration de la matrice
	M = zeros(Float64, taille_matrice, taille_matrice)
	
	
	# Parcoure et remplissage de la matrice
	for i = 1:taille_matrice
		for j=1:taille_matrice
			x,y=coordonnees(i, j, h_, taille_espace)
			r,lambda=conversion_polaire(x, y)
			#println("x=",x,"  y=",y,"  r=",r)
			if r >= a_
				# M[i,j]=abs(calculUp(r, lambda, Cm, Np)+calculUinc(r, lambda, Dm, Np))
				M[i,j]=abs(calculUp(r, lambda, Cm, Np)+calculUinc_exact(x,y,alpha_,k))
				# M[i,j]=real(calculUinc_exact(x,y,alpha_,k))

				# M[i,j]=real(calculUinc(r, lambda, Dm, Np))
				#M[i,j]=real(calculUp(r, lambda, Cm, Np))
				#println(" autre=",r)
			end
		end
	end
	
	# Affichage graphique
	
	imshow(transpose(M), extent=(-5, 5, -5, 5))
	colorbar()
	savefig("res1d.svg")
end


########### CODE #############

dim1(h, a, alpha, alphap, bp, rp)

