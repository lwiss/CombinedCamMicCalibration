function X_mic=mapXmic_toX_cam(X_cam,R,T)

X_mic=R*(X_cam-T);

end
