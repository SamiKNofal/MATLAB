clear all
clc
Zbus = 0;
Ybus = 0;
Quit = 0; 
Branches = 0;
BusBars = 0;
BusBarCon = 0;
M_Size = 0;
Condition = 0;
i = 0;
k = 0;
j = 0;
v = 0;
Alpha = 0;
Beta = 0;


while Quit == 0
    
    disp('The following code calculates the Z-bus matrix using the buildup algorithm.');
    disp('Developed by Sami Khaled Nofal, ID: 0138086, Faculty of Engineering and Technoogy - The University of Jordan.');
    disp('To specify the connection type between each branch use the following inputs:');
    disp('(1) - A branch is connected from a new bus to reference.');
    disp('(2) - A branch is connected from an existing bus to new bus.');
    disp('(3) - A branch is connected from an existing bus to reference.');
    disp('(4) - A branch is connected from an existing bus to another existing bus.');
    
    Branches = input('Please enter the number of branches: ');
    BusBars = input('Please enter the number of busbars: ');
    
    for i = 1:Branches
        if i == 1
            disp('Insert the impedance of branch #');
            disp(i);
            Impedance(i) = input('Impedance: ');
            disp('Busbar 1 to reference impedance: ');
            disp(Impedance(i));
            disp('----------------------------------------');
            Zbus = [Impedance(i)];
            v = v + 1;
        else
            disp('Insert the impedance of branch #');
            disp(i);
            Impedance(i) = input('Impedance: ');
            disp('Insert the branch connection condition');
            Condition(i) = input('Condition: ');
            if Condition(i) == 4 
                disp('Insert the number of the two existng busbars connection in order.');
                BusBarCon(Alpha+1) = input('First busbar: ');
                Alpha = Alpha+1;
                BusBarCon(Alpha+1) = input('Second busbar: ');
                Alpha = Alpha+1;
            end
            switch Condition(i)
                case 1
                    v = v + 1;
                    disp('New busbar to reference.');
                    disp('Busbar number: ');
                    disp(v);
                    disp('With impedance: ');
                case 2
                    v = v + 1;
                    disp('Existing busbar to new busbar');
                    disp('Existing busbar: ');
                    disp(v-1);
                    disp('New busbar: ');
                    disp(v);
                    disp('With impedance: ');
                    disp(Impedance(i));
                case 3
                    disp('Existing busbar to ref');
                    disp('Busbar number: ');
                    disp(v);
                    disp('With impedance: ');
                    disp(Impedance(i));
                case 4
                    disp('Existing busbar to another existing busbar');
                    disp('1st existing busbar number: ');
                    disp(BusBarCon(Beta+1));
                    Beta = Beta + 1;
                    disp('2nd existing busbar number: ');
                    disp(BusBarCon(Beta+1));
                    Beta = Beta + 1;
                    disp('With impedance: ');
                    disp(Impedance(i));
            end
            disp('----------------------------------------');
        end
    end
    
    Alpha = 0;
    
    for i = 2:Branches
       switch Condition(i)
           case 1
                M_Size = size(Zbus);
                Zbus(M_Size(1)+1, M_Size(2)+1) = 0;
                M_Size = size(Zbus);
                Zbus(M_Size(1), M_Size(2)) = Impedance(i);
           case 2
                M_Size = size(Zbus);
                Zbus(:, M_Size(2)+1) = Zbus(:, M_Size(2));
                Zbus(M_Size(1)+1, :) = Zbus(M_Size(1), :);
                M_Size = size(Zbus);
                Zbus(M_Size(1), M_Size(2)) = 0;
                Zbus(M_Size(1), M_Size(2)) = Impedance(i)+Zbus(M_Size(1)-1, M_Size(2)-1);
           case 3
                M_Size = size(Zbus);
                Zbus(:, M_Size(2)+1) = Zbus(:, M_Size(2));
                Zbus(M_Size(1)+1, :) = Zbus(M_Size(1), :);
                M_Size = size(Zbus);
                Zbus(M_Size(1), M_Size(2)) = 0;
                Zbus(M_Size(1), M_Size(2)) = Impedance(i)+Zbus(M_Size(1)-1, M_Size(2)-1);
                M_Size = size(Zbus);
                for k = 1:(M_Size(1)-1)
                   for j = 1:(M_Size(1)-1)
                      Zbus(k, j) =  Zbus(k, j) - ((Zbus(k, M_Size(1)))*(Zbus(M_Size(1), j))/Zbus(M_Size(1), M_Size(2)));
                   end
                end
                Zbus(M_Size(1), :) = [];
                Zbus(:, M_Size(2)) = [];
           case 4
                j = BusBarCon(Alpha+1);
                Alpha = Alpha+1;
                k = BusBarCon(Alpha+1);
                Alpha = Alpha+1;
                M_Size = size(Zbus);
                Zbus(:, M_Size(2)+1) = Zbus(:, j) - Zbus(:, k);
                Zbus(M_Size(1)+1, :) = Zbus(j ,:) - Zbus(k ,:);
                M_Size = size(Zbus);
                Zbus(M_Size(1), M_Size(2)) = Zbus(j, j) + Zbus(k, k) + Impedance(i) - 2*Zbus(j, k);
                M_Size = size(Zbus);
                for k = 1:(M_Size(1))
                    for j = 1:(M_Size(1))
                        Zbus(k, j) =  Zbus(k, j) - ((Zbus(k, M_Size(1)))*(Zbus(M_Size(1), j))/Zbus(M_Size(1), M_Size(2)));
                    end
                end
                Zbus(M_Size(1), :) = [];
                Zbus(:, M_Size(2)) = [];
       end 
    end
    Quit = 1;
end
Zbus = Zbus
Ybus = inv(Zbus)
