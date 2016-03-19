def bubble_sort(elements)

    begin
        swapped = false
        for i in 0..elements.length-2
            if elements[i] > elements[i+1]
                elements[i], elements[i+1] = elements[i+1], elements[i]
                swapped = true
            end
        end
    end until !swapped

    return elements
end

def bubble_sort_by(elements, &comparator)
    begin
        swapped = false
        for i in 0..elements.length-2
            if comparator.call(elements[i], elements[i+1]) > 0
                elements[i], elements[i+1] = elements[i+1], elements[i]
                swapped = true
            end
        end
    end until !swapped

    return elements
end

if __FILE__ == $0
    
    #print bubble_sort([4,3,78,2,0,2])
    #puts
    #print bubble_sort([1,2,3,2,0,2])
    #puts
    #print bubble_sort([4,3,-12,2,0,-21])
    #puts
    result =  bubble_sort_by(["hi","hello","hey"]) do |left,right|
        left <=> right
    end

    print result
end