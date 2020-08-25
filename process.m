function X = process( raw )

%PROCESS Function to process the information into categories

% initialize the output

X = zeros(size(raw));

[N,d] = size(X);

text_col = zeros(1,d);

% find the text columns

for value = 1:d

    for i = 1:N

        if ischar(cell2mat(raw(i,value)))

            text_col(value) = 1;

        end

    end

end

% Add the entries to the matrix

for value = 1:d

   if text_col(value)

      % get the text column first

      text = [];

      for i = 1:N

         x = cell2mat(raw(i,value));

         if ~sum(isnan(x))

             text = [text cellstr(raw(i,value))];

         else

             text = [text '-'];

         end

      end

      % get the unique entries

      Uid = unique(text);

      

      ent = length(Uid);

      % place the element ID in the output

      for i = 1:N

          if strcmp(text(i),' ')

              X(i,value) = NaN;

          else

              for jj = 1:ent

                 if strcmp(text(i),Uid(jj))

                    X(i,value) = jj;

                 end

              end

          end

      end

      

   else

      for i = 1:N

         X(i,value) = cell2mat(raw(i,value));      

      end    

   end

end





end



