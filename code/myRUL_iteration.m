function RUL = myRUL_iteration(A, state_probabilities)
    
    temp(:,:) = RUL_calc(A, state_probabilities);
    rowVector(:) = temp(end,:);
    T =length(rowVector);
    
    % from Markov's For a random variable having an expectation, E ⁡ ( X ) = ∫ 0 ∞ F ¯ X ( x ) d x − ∫ − ∞ 0 F X ( x ) d x {\displaystyle \operatorname {E} (X)=\int _{0}^{\infty }{\bar {F}}_{X}(x)\,dx-\int _{-\infty }^{0}F_{X}(x)\,dx}
    
    
    RUL = sum(1 - rowVector);
    % pdf = temp' * [0 0 1 0]' * A{1}(3,4);

   %  % RUL = find( rowVector > 0.50 , 1, "first");
   %  for t = 1 : T
   %      mu(t) = pdf(t) * t;
   %      var(t) = pdf(t) - mu(t) * t;
   % end
end