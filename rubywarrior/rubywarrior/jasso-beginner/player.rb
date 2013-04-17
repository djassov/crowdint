class Player

  def initialize
      @health =20
      @minHealth=16
      @mhr=false
      @direction = :forward
      @attacks=0
      @frontpano = []
      @backpano =[]
      @first=false
      @initAttack={"front" =>0,"back" =>0}
      @enemies={"nothing"=>0,"Thick Sludge" =>10,"Archer" => 20,"Wizard" =>30}
      
  end
  def play_turn(warrior)
    
    if !defined? warrior.feel
      warrior.walk!(@direction)
    else
      
        if doPivot(warrior)
          @first = true
          return true
        end
        
        
        if !defined? warrior.shoot
          @minHealth=9
          @mhr=false
        end
        
        
        if shootWizard(warrior)
          return false
        end
      
        #if warrior.feel(:backward).empty? && !@first
        #  @direction = (@direction == :forward)? :backward : :forward
        #  puts "aqui->" + @direction.to_s
        #  warrior.walk!(@direction) unless doPivot(warrior)
        #  @first = true
        #  return true
        #end
        #@first = true
        
        
        
        if warrior.feel(@direction).wall?
          @direction = (@direction == :forward)? :backward : :forward
        end
        
        
        #puts @direction
        
        if warrior.feel(@direction).enemy?
          puts @Health.to_i
            if defined? warrior.feel && warrior.feel.to_s ="Thick Sludge"
              @minHealth=16
              warrior.attack!(@direction) unless increaseHealth(warrior)
            end
            warrior.attack!(@direction)
            @attacks +=1
          
          
        elsif warrior.feel(@direction).captive?
            warrior.rescue!(@direction)
        else
           #getPanorama(warrior)
           @attacks =0
            warrior.walk!(@direction) unless increaseHealth(warrior)
        end
        if defined? warrior.health
        @health = warrior.health.to_i
        else
          @health=20
        end
        
    end #puts @health
     
  end
  
  def increaseHealth(warrior)
    h0=@health.to_i
    if defined? warrior.health
    h1=warrior.health.to_i
    else
      h1=20
    end
    
   
    if h0 >h1
      if warrior.feel(@direction).empty?
        if h0 <= @minHealth.to_i
          warrior.walk!((@direction == :forward)? :backward : :forward)
          return true
        else
          return false
        end       
      else
        if h0 <= @minHealth.to_i
          warrior.walk!((@direction == :forward)? :backward : :forward)
          return true
        else
          return false
        end
        
      end
     
    end
    
         
        
          if h1 <= @minHealth.to_i || !@mhf
          if warrior.health.to_i >= 18
              @mhr = true
              return false
          
            end
          warrior.rest!
          return true
        end
        
      
      return false
      
    
  end
  
  def doPivot(warrior)
    if warrior.feel.wall?
      #puts warrior.feel.wall?.to_s
        if defined? warrior.pivot!
          warrior.pivot!
          @first=true
        else
          @direction = (@direction == :forward)? :backward : :forward
          warrior.walk!(@direction)
        end  
        return true
      end
    return false
  end
  
  def getPanorama(warrior)
    if defined? warrior.look
      @frontpano = warrior.look
      @backpano =warrior.look(:backward)
    #elsif defined? warrior.feel
     # @frontpano[0]=warrior.feel
      #@backpano[0]=warrior.feel(:backward)
      
    end
    
  end
  
  def shootWizard(warrior)
    getPanorama(warrior)
    @backpano.each do |elem|
      if (elem.to_s == "Thick Sludge") || (elem.to_s == "Sludge")
        if @direction == :backward
          warrior.pivot!
          @direction = :forward
          return true
        end
      end
      if elem.to_s == "Captive"
        warrior.pivot!
        return true
        #@direction = (@direction == :forward)? :backward : :forward
        #return false
      end
      
      if elem.to_s == "Archer" || elem.to_s == "Wizard"
          warrior.shoot!(:backward)
        
        return true
      end
      
    end
    
    @frontpano.each do |elem|
      if (elem.to_s == "Thick Sludge") || (elem.to_s == "Sludge") || (elem.to_s == "Captive")
        if warrior.feel.empty?
          puts warrior.feel.empty?
          #warrior.walk!
          return false
        end
        return false
      end
      
      if (elem.to_s == "Archer") || (elem.to_s == "Wizard")
        if !defined? warrior.shoot!
          warrior.attack!
        else
          warrior.shoot!
        end
        return true
      end
      
    end

    return false
    
    end
  end

